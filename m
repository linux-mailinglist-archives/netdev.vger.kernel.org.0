Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4717131C76
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgAFXgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:36:45 -0500
Received: from mail-eopbgr20053.outbound.protection.outlook.com ([40.107.2.53]:32391
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726735AbgAFXgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 18:36:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0gPdmFMtIASgGQlKlhXCs+V3zYWxA8C3AtyfVC7oykjhO3FgstldlMhPGIJmP9zmZM1v26ok0hi5tugy+WC7asQrccj/4WcqTGhQAZyQtfCnNKQKZHaZ5V5/OZGNzSJbxcBv/30nTHhPyQLMO7VplVqqpqy7HrPSig9WQXoUqjpLx+HrRcaG/xf5l9oxDZZ1UbLpTuaHTvc6sEM5skeUnaL38ovvcFQiOupCIpP4JP9j1xxdhFamVw9lrfKX5HjCAa4prO1eZ1FCeS6d7DEmMUbhHdA1K2DPGwZ1j7qumYZeNE7ij6QH9DGf6PKu0zLqWEKoHh6Z0BWBT/LlU8jGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZptRjQBL6taTdzXIYNyQyn8zgwdUFkhJBbkbRNw+beQ=;
 b=KtdM+mgt+6/iQYKI0J6w3GLnIZFZCfIZAAIP3v/2nbsMbwakoFsH2JNS67U9HsMp96LiAjic9jKSBOdJj51wJrs4LOtJ6iCyRyYqLrU27UPNn4aJovM8JLPobsyz0aP4MfVB2Z+LsZlEVkNk6DLvmFh0EkEKMUzl7Q7WEnNrle3omzFhW6MoevcvS5dn/1IY+p1fcG6pWFAos36SuzDlyonCXjhWME9vOOGgaxyibBb2duH5gzcUzKe8G4Nd0knw27YzGmxXsqdSXBiBemwApjrxYZkKj2Oy0NLULNWuOgAMpjYLB959CS9BIoR3GSpGA3tn9c8kOgR93/qOLss7sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZptRjQBL6taTdzXIYNyQyn8zgwdUFkhJBbkbRNw+beQ=;
 b=U4m7M8pYCquojqqexwD+6SYDPXhLZsCJ2IxfSpbJSu4fN0tVFDY9LBwLJP/lc9dhW0Y9FX7PvkJois9fwU/TnfBwsR9qatzA6Ce+F95rBpr2CKGVFcghJ9ZBtE/r+weHhXsdoFjd02H9VORAr7cnedfH+oxbwZkICGHHsG740l0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6397.eurprd05.prod.outlook.com (20.179.25.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Mon, 6 Jan 2020 23:36:31 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 23:36:31 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR05CA0090.namprd05.prod.outlook.com (2603:10b6:a03:e0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.3 via Frontend Transport; Mon, 6 Jan 2020 23:36:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/7] net/mlx5: DR, No need for atomic refcount for internal SW
 steering resources
Thread-Topic: [net 5/7] net/mlx5: DR, No need for atomic refcount for internal
 SW steering resources
Thread-Index: AQHVxOofIvJ7NgJ/y0WQPgQn5eb+EQ==
Date:   Mon, 6 Jan 2020 23:36:31 +0000
Message-ID: <20200106233248.58700-6-saeedm@mellanox.com>
References: <20200106233248.58700-1-saeedm@mellanox.com>
In-Reply-To: <20200106233248.58700-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 492f157f-7e1f-4edf-6f51-08d79301422a
x-ms-traffictypediagnostic: VI1PR05MB6397:|VI1PR05MB6397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6397678640CDEB97032ECE23BE3C0@VI1PR05MB6397.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(4326008)(5660300002)(2616005)(956004)(6916009)(54906003)(8936002)(498600001)(6512007)(26005)(107886003)(6666004)(81166006)(8676002)(71200400001)(81156014)(64756008)(66946007)(66446008)(66476007)(66556008)(52116002)(6486002)(6506007)(1076003)(86362001)(36756003)(16526019)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6397;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EYKALpROzWTTtpXLLsoIBgu2l8yFPM9wwQac7mhF1orf+LJGgOqtxcIV7fU/KQ9NWMudTWb7D1fpi9ppH7BxlrSw1wySV/v2eqLWhDd5UVlX4Osd6fJa6obP/r3vZX/AMG1eEzxKY8h9cbRkjdyy2E9WQBlddtckHEE/GA/vnUjlMDEzcSCXoRojqwT2kK4mhVgk08r44++5djXO+AROE3zilga9Yfhz7zvNDbUjeguPuip0LkIUEcebrBqFeKAE3VX4/BaWB4c71KK6fiP8wdfLHvgd2VUm4vamWCgR2L+9dTZnfiJYD1bs8EA/VPCDMQFgGiU4uattaWRCUklOAf4BJla8PsqQJCxTu1YVlURfHt/yhCNR99OmQcmBfhWaF/fEl/MrmzKLOjWu6G8zabTx0OxDyByOsY3LxfDfAYjQMQm2O9UxMXcBxnG4+/ntZVmuji+P6wWHOG4UUDKuV+XpMzzomNkXchjG+aYKjwYzI+uYTOfG5MKxMDmrh2hYzeuLUe/KONaKIkWbtcs69HWhrYeOIJGDb901JhqrjwY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 492f157f-7e1f-4edf-6f51-08d79301422a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 23:36:31.4040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lX1HJ+LF3fyeQGx3SobcDNt/BpoqVGV5MkmZwuTbOvDgKYQ5M+yBdRmyGKComkhu2Y0varfnHHhjBf4K/x603w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6397
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@mellanox.com>

No need for an atomic refcounter for the STE and hashtables.
These are internal SW steering resources and they are always
under domain mutex.

This also fixes the following refcount error:
  refcount_t: addition on 0; use-after-free.
  WARNING: CPU: 9 PID: 3527 at lib/refcount.c:25 refcount_warn_saturate+0x8=
1/0xe0
  Call Trace:
   dr_table_init_nic+0x10d/0x110 [mlx5_core]
   mlx5dr_table_create+0xb4/0x230 [mlx5_core]
   mlx5_cmd_dr_create_flow_table+0x39/0x120 [mlx5_core]
   __mlx5_create_flow_table+0x221/0x5f0 [mlx5_core]
   esw_create_offloads_fdb_tables+0x180/0x5a0 [mlx5_core]
   ...

Fixes: 26d688e33f88 ("net/mlx5: DR, Add Steering entry (STE) utilities")
Signed-off-by: Yevgeny Kliteynik <kliteyn@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 10 +++++-----
 .../mellanox/mlx5/core/steering/dr_types.h         | 14 ++++++++------
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 32e94d2ee5e4..f21bc1bc77d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -209,7 +209,7 @@ static void dr_rule_rehash_copy_ste_ctrl(struct mlx5dr_=
matcher *matcher,
 	/* We need to copy the refcount since this ste
 	 * may have been traversed several times
 	 */
-	refcount_set(&new_ste->refcount, refcount_read(&cur_ste->refcount));
+	new_ste->refcount =3D cur_ste->refcount;
=20
 	/* Link old STEs rule_mem list to the new ste */
 	mlx5dr_rule_update_rule_member(cur_ste, new_ste);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index a5a266983dd3..c6c7d1defbd7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -348,7 +348,7 @@ static void dr_ste_replace(struct mlx5dr_ste *dst, stru=
ct mlx5dr_ste *src)
 	if (dst->next_htbl)
 		dst->next_htbl->pointing_ste =3D dst;
=20
-	refcount_set(&dst->refcount, refcount_read(&src->refcount));
+	dst->refcount =3D src->refcount;
=20
 	INIT_LIST_HEAD(&dst->rule_list);
 	list_splice_tail_init(&src->rule_list, &dst->rule_list);
@@ -565,7 +565,7 @@ bool mlx5dr_ste_is_not_valid_entry(u8 *p_hw_ste)
=20
 bool mlx5dr_ste_not_used_ste(struct mlx5dr_ste *ste)
 {
-	return !refcount_read(&ste->refcount);
+	return !ste->refcount;
 }
=20
 /* Init one ste as a pattern for ste data array */
@@ -689,14 +689,14 @@ struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct =
mlx5dr_icm_pool *pool,
 	htbl->ste_arr =3D chunk->ste_arr;
 	htbl->hw_ste_arr =3D chunk->hw_ste_arr;
 	htbl->miss_list =3D chunk->miss_list;
-	refcount_set(&htbl->refcount, 0);
+	htbl->refcount =3D 0;
=20
 	for (i =3D 0; i < chunk->num_of_entries; i++) {
 		struct mlx5dr_ste *ste =3D &htbl->ste_arr[i];
=20
 		ste->hw_ste =3D htbl->hw_ste_arr + i * DR_STE_SIZE_REDUCED;
 		ste->htbl =3D htbl;
-		refcount_set(&ste->refcount, 0);
+		ste->refcount =3D 0;
 		INIT_LIST_HEAD(&ste->miss_list_node);
 		INIT_LIST_HEAD(&htbl->miss_list[i]);
 		INIT_LIST_HEAD(&ste->rule_list);
@@ -713,7 +713,7 @@ struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct ml=
x5dr_icm_pool *pool,
=20
 int mlx5dr_ste_htbl_free(struct mlx5dr_ste_htbl *htbl)
 {
-	if (refcount_read(&htbl->refcount))
+	if (htbl->refcount)
 		return -EBUSY;
=20
 	mlx5dr_icm_free_chunk(htbl->chunk);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 290fe61c33d0..3fdf4a5eb031 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -123,7 +123,7 @@ struct mlx5dr_matcher_rx_tx;
 struct mlx5dr_ste {
 	u8 *hw_ste;
 	/* refcount: indicates the num of rules that using this ste */
-	refcount_t refcount;
+	u32 refcount;
=20
 	/* attached to the miss_list head at each htbl entry */
 	struct list_head miss_list_node;
@@ -155,7 +155,7 @@ struct mlx5dr_ste_htbl_ctrl {
 struct mlx5dr_ste_htbl {
 	u8 lu_type;
 	u16 byte_mask;
-	refcount_t refcount;
+	u32 refcount;
 	struct mlx5dr_icm_chunk *chunk;
 	struct mlx5dr_ste *ste_arr;
 	u8 *hw_ste_arr;
@@ -206,13 +206,14 @@ int mlx5dr_ste_htbl_free(struct mlx5dr_ste_htbl *htbl=
);
=20
 static inline void mlx5dr_htbl_put(struct mlx5dr_ste_htbl *htbl)
 {
-	if (refcount_dec_and_test(&htbl->refcount))
+	htbl->refcount--;
+	if (!htbl->refcount)
 		mlx5dr_ste_htbl_free(htbl);
 }
=20
 static inline void mlx5dr_htbl_get(struct mlx5dr_ste_htbl *htbl)
 {
-	refcount_inc(&htbl->refcount);
+	htbl->refcount++;
 }
=20
 /* STE utils */
@@ -254,14 +255,15 @@ static inline void mlx5dr_ste_put(struct mlx5dr_ste *=
ste,
 				  struct mlx5dr_matcher *matcher,
 				  struct mlx5dr_matcher_rx_tx *nic_matcher)
 {
-	if (refcount_dec_and_test(&ste->refcount))
+	ste->refcount--;
+	if (!ste->refcount)
 		mlx5dr_ste_free(ste, matcher, nic_matcher);
 }
=20
 /* initial as 0, increased only when ste appears in a new rule */
 static inline void mlx5dr_ste_get(struct mlx5dr_ste *ste)
 {
-	refcount_inc(&ste->refcount);
+	ste->refcount++;
 }
=20
 void mlx5dr_ste_set_hit_addr_by_next_htbl(u8 *hw_ste,
--=20
2.24.1

