Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0E19BC50F
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 11:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504340AbfIXJmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 05:42:09 -0400
Received: from mail-eopbgr10079.outbound.protection.outlook.com ([40.107.1.79]:4229
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504324AbfIXJmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 05:42:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOv6DVp4+tu52F0pAGcDFboSFMo3VdbyG0rEU6PzjqUYhpFWkGEvVAjx+MrxWuu7zLC9FhEvBPKCjbXNzOvPnaGoQ1NAdp+7a8wrFZVXOqF+T4fiDYVF2tbKtQsSLo9DEG5ndldh1HY2bqWpxns/1+4WqCEdhHn2wEgNRuQBlbVpED/ZfH+iGlTjR2QQnFL0OfuErwj1PACTxfwg5apxjZaL4KBLLz20XAYqVlHFm4JF6weDKSlomO0jQ4ytseF0bJ8sd52C+71niMjhI3oB0BTKDSx6LNmSaRutYfHxzesXsEn6krJivg1sWIaIeBUrx9yL4FLDZ9RVR6LALZF4KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6xpNB5uB4uF5b40Am3eQOh8mtELYJa1IQaE8V6iTwc=;
 b=i1btMzNboianOEafeup4bBMNuA1zU66aruxZ2yU7xjmQ4R9eWysfIJYEH8RDjy/ULJ6bvKfm7q9lEP4GIS6UejYd1/z/HbceR5ndL+GHBTQLYPES9Tt/CbfgqFoSQDX5MSt1/sEwiwie4K4QngYlFeKiHzdqVZ38S6hbvZL735Tm8babIyDeas4cfhZKpn0ZnOo4kYp5Ygxs2YI6YEoEXd3kzB4s9AV09KCIFDQ96PWbi5ctbeG5DqTwwkqDkIUKwFO6BlbSGDZXcTNvIGg8xiK3WCmQgwjJVR92Niuzej45Dz7ExmzxK6qK6uZr3fmNDGQGYjciIpsHP+k6ez0j6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6xpNB5uB4uF5b40Am3eQOh8mtELYJa1IQaE8V6iTwc=;
 b=c9J2m0wOOHntC4/suEORRGa/Y5zd7jqN5FlbOql+WjclZ/M9nGF9FK/PEuLsiSDH2EzgRhp2PTLuIP2PHtR71/86NT8wei5SAm9GThRo8ttOsGyWRuOQ2jB42rWqZ5U0W/Ze7yxpuWboIbZx50efz4WjXa2NmTQuXUZ9/Ppscjs=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2671.eurprd05.prod.outlook.com (10.172.14.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Tue, 24 Sep 2019 09:41:30 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 09:41:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/7] net/mlx5: DR, Fix getting incorrect prev node in ste_free
Thread-Topic: [net 3/7] net/mlx5: DR, Fix getting incorrect prev node in
 ste_free
Thread-Index: AQHVcrw+Hk0VcygfqEy3kWfNRP4LBw==
Date:   Tue, 24 Sep 2019 09:41:30 +0000
Message-ID: <20190924094047.15915-4-saeedm@mellanox.com>
References: <20190924094047.15915-1-saeedm@mellanox.com>
In-Reply-To: <20190924094047.15915-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [193.47.165.251]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4439c47-6bc2-4a8b-fa54-08d740d360a9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2671;
x-ms-traffictypediagnostic: VI1PR0501MB2671:|VI1PR0501MB2671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2671A0F6748FD1FBC5A02D2CBE840@VI1PR0501MB2671.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(189003)(199004)(386003)(256004)(6512007)(186003)(6116002)(3846002)(50226002)(99286004)(36756003)(25786009)(107886003)(486006)(6436002)(102836004)(52116002)(26005)(76176011)(8676002)(4326008)(316002)(81156014)(81166006)(2616005)(54906003)(476003)(11346002)(6916009)(6506007)(86362001)(1076003)(5660300002)(66476007)(2906002)(66556008)(6486002)(66446008)(64756008)(66946007)(14454004)(478600001)(305945005)(7736002)(66066001)(71190400001)(446003)(71200400001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2671;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4rd7vB6fHoQKwpQH5OLoV8TBXIDTio8nvGnlp6YddPgfdXJYC+tCxLZagTURDolzZ/aaqFujsKMQqcekwDEcwAFuTdoGbg6xErubSxrN2uAaGKRLoeJmPLS6cW+ScWQajzDeblB82Q6Q0B2kgx/9Fi0v2ewnsASiapOsVIFwkg4RjHfJvMCyOe2mYqnd2YXB0Oeo91PqPDjbuvIzeUi1WrO/Cfu5tuUZujFzWs4zJReDsPynGlFnPN1NwFRpwJRMHX69XlVvQsbcxtMakLP8qUC1aaba9R1KAXD/jqlt3T1ktwRakKr8jisyrLso4QQU4aH2oQn9ttEpmXKkpdOB5AqQb6MPN2cbptR/qVCdjYTfEtZMkI8dv0vdhMbPvc5X9d5ZpEfEhcCwRDcp8HQOjkg8KNzX7bKuxzGPITg8GLg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4439c47-6bc2-4a8b-fa54-08d740d360a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 09:41:30.4512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5hMtX/yykGwnmfMaKJlXMQJfH49foq1NAkfCePeyPt2GBtsIuzJp6Cb7UtKcgbf6lEAu/Hcv4xN+md6LIEvsMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

When we free an STE and the STE is in the middle of collision
list, the prev_ste was obtained incorrectly from the list.
To avoid such issues list_entry calls replaced with standard list API.

Fixes: 26d688e33f88 ("net/mlx5: DR, Add Steering entry (STE) utilities")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c       | 10 ++++------
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 14 +++++---------
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c =
b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 01008cd66f75..9c2c25356dd0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -458,13 +458,11 @@ static int dr_matcher_add_to_tbl(struct mlx5dr_matche=
r *matcher)
=20
 	prev_matcher =3D NULL;
 	if (next_matcher && !first)
-		prev_matcher =3D list_entry(next_matcher->matcher_list.prev,
-					  struct mlx5dr_matcher,
-					  matcher_list);
+		prev_matcher =3D list_prev_entry(next_matcher, matcher_list);
 	else if (!first)
-		prev_matcher =3D list_entry(tbl->matcher_list.prev,
-					  struct mlx5dr_matcher,
-					  matcher_list);
+		prev_matcher =3D list_last_entry(&tbl->matcher_list,
+					       struct mlx5dr_matcher,
+					       matcher_list);
=20
 	if (dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_FDB ||
 	    dmn->type =3D=3D MLX5DR_DOMAIN_TYPE_NIC_RX) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 3bc3f66b8fa8..4187f2b112b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -18,7 +18,7 @@ static int dr_rule_append_to_miss_list(struct mlx5dr_ste =
*new_last_ste,
 	struct mlx5dr_ste *last_ste;
=20
 	/* The new entry will be inserted after the last */
-	last_ste =3D list_entry(miss_list->prev, struct mlx5dr_ste, miss_list_nod=
e);
+	last_ste =3D list_last_entry(miss_list, struct mlx5dr_ste, miss_list_node=
);
 	WARN_ON(!last_ste);
=20
 	ste_info_last =3D kzalloc(sizeof(*ste_info_last), GFP_KERNEL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 6b0af64536d8..95b7221f5730 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -429,12 +429,9 @@ static void dr_ste_remove_middle_ste(struct mlx5dr_ste=
 *ste,
 	struct mlx5dr_ste *prev_ste;
 	u64 miss_addr;
=20
-	prev_ste =3D list_entry(mlx5dr_ste_get_miss_list(ste)->prev, struct mlx5d=
r_ste,
-			      miss_list_node);
-	if (!prev_ste) {
-		WARN_ON(true);
+	prev_ste =3D list_prev_entry(ste, miss_list_node);
+	if (WARN_ON(!prev_ste))
 		return;
-	}
=20
 	miss_addr =3D mlx5dr_ste_get_miss_addr(ste->hw_ste);
 	mlx5dr_ste_set_miss_addr(prev_ste->hw_ste, miss_addr);
@@ -461,8 +458,8 @@ void mlx5dr_ste_free(struct mlx5dr_ste *ste,
 	struct mlx5dr_ste_htbl *stats_tbl;
 	LIST_HEAD(send_ste_list);
=20
-	first_ste =3D list_entry(mlx5dr_ste_get_miss_list(ste)->next,
-			       struct mlx5dr_ste, miss_list_node);
+	first_ste =3D list_first_entry(mlx5dr_ste_get_miss_list(ste),
+				     struct mlx5dr_ste, miss_list_node);
 	stats_tbl =3D first_ste->htbl;
=20
 	/* Two options:
@@ -479,8 +476,7 @@ void mlx5dr_ste_free(struct mlx5dr_ste *ste,
 		if (last_ste =3D=3D first_ste)
 			next_ste =3D NULL;
 		else
-			next_ste =3D list_entry(ste->miss_list_node.next,
-					      struct mlx5dr_ste, miss_list_node);
+			next_ste =3D list_next_entry(ste, miss_list_node);
=20
 		if (!next_ste) {
 			/* One and only entry in the list */
--=20
2.21.0

