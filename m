Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83AA410453A
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKTUgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:36:43 -0500
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:18430
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725787AbfKTUgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 15:36:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hS9Utm5U9+QjX6zHuL/PUxD6uYNf+0hv8TLWCPZaPiDiS9Mei6FySoN7iVw9YMDxUI7b7IMskfK450nJoy4pR4cY/SndhtXEODqJxb4LLs8gRZ6YL467mtmUZD67NbsRSkkA2ee/lxdidfyHAgPA0m/ufI3QG69ULFRo5QhWgolv+DrqDk8yi52WaX1w25RB3tN8x8KSAjxT1IlnCaaEsMFj1BNl/0N1E0K9JDHvSEBU50vUoTGE7weU5d0Hd6wEJvREvLpvhc7Nmy4OcAIw6groNdEI2uiMJbfaIPEZKmBxwOLDwBwKkYyxVa1e4ja7zP8UJwGQxg15M8ZPe/fNTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/EID1OjPkPmwQMkuWT6gLa8bUPWU1QeQQWHEt6lhBQ=;
 b=T+EYt4xy/0ewdcnXjPbzzDctCvC+JR1TOIZvkbDZ/4uOBFhwMBf0iWBJ+Uzq4MhHo3vL//2PDIffhlugnlykV4ycjsmiQMBWuCctA1AUwMWw4sA2531y1uWEVWDVMH4APJYCLw6mRu6BGWfuxz5ck3ixnh/3kZQb+OE65HxGM8K1gqSG6U5ZvcKX7HAyDh/A0idCRXi+/Ytd+mpa9zJuQmCfAnrfTmCxJcxoZ0GMK7OrSsy0QEubGCpItg28J+qDRMVV6JyWLXFLJfJDxVeBTyBDzFz2NBikcd2tZAV3Fq/MnJcTBbji84pkgk0kNKU4/dyl4N7xWguKKcL2WJ9yQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/EID1OjPkPmwQMkuWT6gLa8bUPWU1QeQQWHEt6lhBQ=;
 b=FsImn12opuvgHAhv7IsWVUQVSfIW3ixsX6LIGpdeOGmzy13ksj2S6qYGCtdt2nINxMu0nH4bvpyP6OqJWl6rnLIlSe058tImYZqHxM2KNB82BtS4hEhZ9Ymoq4jZSp9H/ne87OLPyQgxDnB/EpG7Sen7MJzzSgkdzPWq9wH9Cog=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6110.eurprd05.prod.outlook.com (20.178.204.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 20:35:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 20:35:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 06/12] net/mlx5: DR, Limit STE hash table enlarge based on
 bytemask
Thread-Topic: [net 06/12] net/mlx5: DR, Limit STE hash table enlarge based on
 bytemask
Thread-Index: AQHVn+IaTSmbfI7iKUSEWMLcE7v5ng==
Date:   Wed, 20 Nov 2019 20:35:53 +0000
Message-ID: <20191120203519.24094-7-saeedm@mellanox.com>
References: <20191120203519.24094-1-saeedm@mellanox.com>
In-Reply-To: <20191120203519.24094-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:a03:54::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aeb45977-25e1-40a3-b8e4-08d76df93ccd
x-ms-traffictypediagnostic: VI1PR05MB6110:|VI1PR05MB6110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6110D2FBAE823EBA7B009595BE4F0@VI1PR05MB6110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(66946007)(6512007)(446003)(11346002)(66476007)(64756008)(2616005)(476003)(52116002)(14444005)(76176011)(107886003)(5660300002)(8936002)(66446008)(66556008)(186003)(26005)(478600001)(25786009)(14454004)(6506007)(6436002)(386003)(8676002)(50226002)(81156014)(102836004)(99286004)(2906002)(81166006)(6486002)(71200400001)(256004)(7736002)(305945005)(36756003)(4326008)(486006)(6916009)(54906003)(316002)(71190400001)(1076003)(66066001)(3846002)(6116002)(86362001)(161623001)(147533002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6110;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AuRZmAbAXcS2sYm+kfH6k0sf2yuMmuAgMcBRPjFhaEXeOPpZ9csjMNu6OX8GiMZoRaaU2pagLYj/JGRrcTPstTgJIX9ooXt56w3K2oP2iIsNTcd6lXg4iTXrwkej0jMHB40nhVbwcJe8VQn5Jy/bKFXBmerxwaJ/d2/6PEpnvxQl3nmb6lhBFCYlCkJ+O9RLIpN75fLVAIUxxHpXoT4BUvBOvc63bxdRXG8lfqs/nzTy3/vDyQoHJRAY/w09I1oLG+7EjeAhpPHGJr/9cS8cDzaJEwuq0AGvZJvqtRUs7eePS0GRPIFaaKVfXKrd1I80jvlq1kTL2NmUYAvQry0xBxdOhLPBnrfm+nvgjOJqOH4qq7fcOm0+PpbbOUTzDD0INY0keKDEpBhwVwrk33yESGtkapBW0u5dr/eMOKihVXp2CdKNlmYO77seNxozQXEv
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeb45977-25e1-40a3-b8e4-08d76df93ccd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 20:35:53.4042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SurqRMHzUuxzyRiRdZBzAa6T18whvY4ARxbMA5N9kcKKoPquCWnY+xc8faQPbNI+FhckN1p+kUaCQvca5LTb1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

When an ste hash table has too many collision we enlarge it
to a bigger hash table (rehash). Rehashing collision improvement
depends on the bytemask value. The more 1 bits we have in bytemask
means better spreading in the table.

Without this fix tables can grow in size without providing any
improvement which can lead to memory depletion and failures.

This patch will limit table rehash to reduce memory and improve
the performance.

Fixes: 41d07074154c ("net/mlx5: DR, Expose steering rule functionality")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_rule.c     | 15 ++++++++++++++
 .../mellanox/mlx5/core/steering/dr_ste.c      | 20 -------------------
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 5dcb8baf491a..bd1699e62142 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -595,6 +595,18 @@ static void dr_rule_clean_rule_members(struct mlx5dr_r=
ule *rule,
 	}
 }
=20
+static u16 dr_get_bits_per_mask(u16 byte_mask)
+{
+	u16 bits =3D 0;
+
+	while (byte_mask) {
+		byte_mask =3D byte_mask & (byte_mask - 1);
+		bits++;
+	}
+
+	return bits;
+}
+
 static bool dr_rule_need_enlarge_hash(struct mlx5dr_ste_htbl *htbl,
 				      struct mlx5dr_domain *dmn,
 				      struct mlx5dr_domain_rx_tx *nic_dmn)
@@ -607,6 +619,9 @@ static bool dr_rule_need_enlarge_hash(struct mlx5dr_ste=
_htbl *htbl,
 	if (!ctrl->may_grow)
 		return false;
=20
+	if (dr_get_bits_per_mask(htbl->byte_mask) * BITS_PER_BYTE <=3D htbl->chun=
k_size)
+		return false;
+
 	if (ctrl->num_of_collisions >=3D ctrl->increase_threshold &&
 	    (ctrl->num_of_valid_entries - ctrl->num_of_collisions) >=3D ctrl->inc=
rease_threshold)
 		return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 80680765d59c..3cbf74b44d1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -560,18 +560,6 @@ bool mlx5dr_ste_not_used_ste(struct mlx5dr_ste *ste)
 	return !refcount_read(&ste->refcount);
 }
=20
-static u16 get_bits_per_mask(u16 byte_mask)
-{
-	u16 bits =3D 0;
-
-	while (byte_mask) {
-		byte_mask =3D byte_mask & (byte_mask - 1);
-		bits++;
-	}
-
-	return bits;
-}
-
 /* Init one ste as a pattern for ste data array */
 void mlx5dr_ste_set_formatted_ste(u16 gvmi,
 				  struct mlx5dr_domain_rx_tx *nic_dmn,
@@ -620,20 +608,12 @@ int mlx5dr_ste_create_next_htbl(struct mlx5dr_matcher=
 *matcher,
 	struct mlx5dr_ste_htbl *next_htbl;
=20
 	if (!mlx5dr_ste_is_last_in_rule(nic_matcher, ste->ste_chain_location)) {
-		u32 bits_in_mask;
 		u8 next_lu_type;
 		u16 byte_mask;
=20
 		next_lu_type =3D MLX5_GET(ste_general, hw_ste, next_lu_type);
 		byte_mask =3D MLX5_GET(ste_general, hw_ste, byte_mask);
=20
-		/* Don't allocate table more than required,
-		 * the size of the table defined via the byte_mask, so no need
-		 * to allocate more than that.
-		 */
-		bits_in_mask =3D get_bits_per_mask(byte_mask) * BITS_PER_BYTE;
-		log_table_size =3D min(log_table_size, bits_in_mask);
-
 		next_htbl =3D mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
 						  log_table_size,
 						  next_lu_type,
--=20
2.21.0

