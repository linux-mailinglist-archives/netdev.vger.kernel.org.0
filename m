Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18F6F758F3
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfGYUgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:36:55 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:18494
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726195AbfGYUgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 16:36:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfzAEX1iqqwgU7F+7vasWRkVwFqnHriJ5QRPtlqjNa/naKrv/X1gHEo641wpT2D3xM8a8PzXqAqfjjf3IWvkyOjqd01iJh+67xZdltA3SdEMe3PAoYhFsokJErizTqOtiTVeXp+V4FRMLS9U/x0W8HdbI20j/TclyzUo3G0/KGgylqHs+YaHMVphaJN7EpQ82TUsar8g3FQRsL+mZL117muL08srxllCg4PVkQ6ws9L0NFMxq2tCt/EcUVQRcHfiqsiYI3ccSS/2LdHrkSVza4by8p7I+D3ciTpcd1mLhVCMwK9sQShVSUkW4EFHbiOAkBzCg/BvTHoyB0VS5yTBOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pqERwIlKC+r4mfLWnJvCU+BgMs1H61847Qo1Oz1BBQ=;
 b=e0VXh+oXWvJpjzrbZ9+3RkGYcPQBbQkMZOvNORIi6br2jw5vek5s9vT19SQdLU3RiYXw52ZYg6Fhbd9Ye6+xunn/jzr/pM58uKBiEcnbFlFWrrVNWzhbAiacBYhNKPZt3sp7pDbOrOshbLWzYAhcx7SL1ii0j+uBqM6x9cGUYwVV4b5YV5o7zxIDWott2ileiGP4XD1hcifcIaGKJjKn4Wi1kOGmZ6YXvA5OW34ffQaGHuOnFIPDQ5egpQLbkVGhZI6TJv+vU/epTRcPoVwX/hFX1jMqw/nLF6kHBOuXx6gs/ct/ZUuVw1K+4Uo4PcHE+Z9D0GrlQjIlgEwAXc81Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pqERwIlKC+r4mfLWnJvCU+BgMs1H61847Qo1Oz1BBQ=;
 b=PeyOEFbG6fvYgM5s2vtyz5WiVAtpVWht60Q83YaaWl4lM/eMyHzF7R+J09yeKgkGv37DgN8Rj7LA45dXAeZSgEc3c1De9ObREAb2AfJokpZAM5tWSZoe8al586tlZvE6F7lL7WnDsdlxM3KSJM1u2kvA/MJ/yL2RQoDy/pYiQVA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2504.eurprd05.prod.outlook.com (10.168.76.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 20:36:46 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 20:36:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 6/9] net/mlx5e: Prevent encap flow counter update async to user
 query
Thread-Topic: [net 6/9] net/mlx5e: Prevent encap flow counter update async to
 user query
Thread-Index: AQHVQyityh2iUD+AQUmmlMVQ87woZA==
Date:   Thu, 25 Jul 2019 20:36:46 +0000
Message-ID: <20190725203618.11011-7-saeedm@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
In-Reply-To: <20190725203618.11011-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:a03:54::19) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf25caac-54f6-4d50-fbf7-08d7113fcfba
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2504;
x-ms-traffictypediagnostic: DB6PR0501MB2504:
x-microsoft-antispam-prvs: <DB6PR0501MB250469EAD0D83EA6608EF26EBEC10@DB6PR0501MB2504.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(2906002)(6512007)(25786009)(305945005)(81166006)(7736002)(8936002)(53936002)(71190400001)(107886003)(476003)(6436002)(2616005)(50226002)(186003)(52116002)(1076003)(71200400001)(386003)(99286004)(6506007)(6116002)(36756003)(14444005)(256004)(81156014)(478600001)(316002)(446003)(11346002)(64756008)(86362001)(66446008)(14454004)(6916009)(8676002)(66946007)(66476007)(4326008)(54906003)(68736007)(66556008)(26005)(76176011)(15650500001)(6486002)(66066001)(486006)(5660300002)(102836004)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2504;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kF1xOwP/iBDAnZiuT9a4XWIuMIFrwr55iG8bBdBtLEY3QZ5EwDa+DbJi0Z3GNtrG2PfsuAMCsk+jNYivGIvv5A/1lO4MbYNxs+NnLS0JPgBBINFMG2zhzIOlfS83MA+U2hTl3lCYH56q2GouS84+63l4oSbRJROpBBTnivbRj7uCpTAs5rQLUKIi9UdgzrZ9tpsX1mYdvmNwpcOrQ9X2HiDM/wiC7mqBawPh3SBP+3X7X26PyUvx88uQhAliEYfbjJVcvo3ZQlsZF3FjzzO3Sxhjlo3xnMb7mFF/nTqQSbxOH8AU1eJuavxUpUfO6tkhA7TNXmHSPJXws4WJqDQPo9MxUWLjEsfalnxGTaDgFJOlJKpNqIDmewI3AO0CGbK6A+hiH4OhNWhNh1UGYavYrz/UeYMA4av79fxBd7ecjpo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf25caac-54f6-4d50-fbf7-08d7113fcfba
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 20:36:46.3943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

This patch prevents a race between user invoked cached counters
query and a neighbor last usage updater.

The cached flow counter stats can be queried by calling
"mlx5_fc_query_cached" which provides the number of bytes and
packets that passed via this flow since the last time this counter
was queried.
It does so by reducting the last saved stats from the current, cached
stats and then updating the last saved stats with the cached stats.
It also provide the lastuse value for that flow.

Since "mlx5e_tc_update_neigh_used_value" needs to retrieve the
last usage time of encapsulation flows, it calls the flow counter
query method periodically and async to user queries of the flow counter
using cls_flower.
This call is causing the driver to update the last reported bytes and
packets from the cache and therefore, future user queries of the flow
stats will return lower than expected number for bytes and packets
since the last saved stats in the driver was updated async to the last
saved stats in cls_flower.

This causes wrong stats presentation of encapsulation flows to user.

Since the neighbor usage updater only needs the lastuse stats from the
cached counter, the fix is to use a dedicated lastuse query call that
returns the lastuse value without synching between the cached stats and
the last saved stats.

Fixes: f6dfb4c3f216 ("net/mlx5e: Update neighbour 'used' state using HW flo=
w rules counters")
Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c | 5 +++++
 include/linux/mlx5/fs.h                               | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index cc096f6011d9..7ecfc53cf5f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1230,13 +1230,13 @@ static struct mlx5_fc *mlx5e_tc_get_counter(struct =
mlx5e_tc_flow *flow)
 void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe)
 {
 	struct mlx5e_neigh *m_neigh =3D &nhe->m_neigh;
-	u64 bytes, packets, lastuse =3D 0;
 	struct mlx5e_tc_flow *flow;
 	struct mlx5e_encap_entry *e;
 	struct mlx5_fc *counter;
 	struct neigh_table *tbl;
 	bool neigh_used =3D false;
 	struct neighbour *n;
+	u64 lastuse;
=20
 	if (m_neigh->family =3D=3D AF_INET)
 		tbl =3D &arp_tbl;
@@ -1256,7 +1256,7 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_ne=
igh_hash_entry *nhe)
 					    encaps[efi->index]);
 			if (flow->flags & MLX5E_TC_FLOW_OFFLOADED) {
 				counter =3D mlx5e_tc_get_counter(flow);
-				mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
+				lastuse =3D mlx5_fc_query_lastuse(counter);
 				if (time_after((unsigned long)lastuse, nhe->reported_lastuse)) {
 					neigh_used =3D true;
 					break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/driver=
s/net/ethernet/mellanox/mlx5/core/fs_counters.c
index b3762123a69c..1834d9f3aa1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -369,6 +369,11 @@ int mlx5_fc_query(struct mlx5_core_dev *dev, struct ml=
x5_fc *counter,
 }
 EXPORT_SYMBOL(mlx5_fc_query);
=20
+u64 mlx5_fc_query_lastuse(struct mlx5_fc *counter)
+{
+	return counter->cache.lastuse;
+}
+
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
 			  u64 *bytes, u64 *packets, u64 *lastuse)
 {
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 04a569568eac..f049af3f3cd8 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -220,6 +220,7 @@ int mlx5_modify_rule_destination(struct mlx5_flow_handl=
e *handler,
=20
 struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging);
 void mlx5_fc_destroy(struct mlx5_core_dev *dev, struct mlx5_fc *counter);
+u64 mlx5_fc_query_lastuse(struct mlx5_fc *counter);
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
 			  u64 *bytes, u64 *packets, u64 *lastuse);
 int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
--=20
2.21.0

