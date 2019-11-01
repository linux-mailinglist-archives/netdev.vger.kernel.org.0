Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C410FECAB4
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfKAWDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:03:07 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:1441
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727176AbfKAWDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 18:03:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gv/rJtkEYy6iz7/apQ9bA3STbXPzdJj91V6+87d3kNBbK53rGmKWY5x9BzSmSnPCO6uxahgszcsn+hdT0cWJdae5l6p2d2lUoy2VEGU8YCnzLOwZqfome5Bq3rAmZX+OTLs3+YajXWRyF1j2M3vWGJpw2phvWX0e/tXCwL11cqgqZWX1YIfDf9Kh5WVQFrup3b459t52T5WpfAaRsoXl5IZGXNGxJINyRghTvevmYFlv9hYhDHtwG/rhPU1epJB+rtGfjbb87b3W7WCoipkmyoeNKCxncohnpNq11+pGk8ZFSlSL+K3Iu+bhrx6SbXfWVch62ALfd2Naabx2/29JPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lx74XHxWQflIlSHuZlxY6JfBomEFDjFEfPkLkAxxpjk=;
 b=dd5OrxpoMLAvZeLWEjAweB8l7yfEtNq+XCCf2KmVZ+Bnuub+unBUSqCHEahxUmM4R2ubx802nB3/gMVUAcZ16HJ2f83zuXYL/4+Po2GQfb2CqOZ7hNffvbr1vJJ3CZelLXFpfsJ+r3iUDipVsZLSxSe6KVWbxQbf26X6OO7blIe0k3YgPipBXSYHOHpNmGgx71GlMdkq5h5nB+INnwBZnHWFrVYNtijVnSLp/zFKtlIfL1shAC00wHQxMdrtiRN/FBKCgw14ikUUUC/1yBwoKyYdLGaVQ/rqI0Gk/IZzIa4JSUBQIMt8eR6JJytVBlabY8zIktXUYX83EoWPRBiztQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lx74XHxWQflIlSHuZlxY6JfBomEFDjFEfPkLkAxxpjk=;
 b=cB5fsfenjet7mkT35759SWTLuJrobwftX93NPFKZTbQZ+6+cGu7AH0Qnvvyn0boohtPRIU3SBP3LYw+u6fWB2i0Kc5qucUNScDRHobgvC2NSuws6Ygwvl7Zrq6lqbFjG9afrrwohL8XjhtsQUP3LBXnDQXWa3vaHyDs6nvmvFFA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3293.eurprd05.prod.outlook.com (10.175.244.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.25; Fri, 1 Nov 2019 21:58:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:58:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hamdan Igbaria <hamdani@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/15] net/mlx5: DR, Replace CRC32 implementation to use
 kernel lib
Thread-Topic: [net-next 01/15] net/mlx5: DR, Replace CRC32 implementation to
 use kernel lib
Thread-Index: AQHVkP+PcUWI7/6xXE20CMQC1TfNQw==
Date:   Fri, 1 Nov 2019 21:58:57 +0000
Message-ID: <20191101215833.23975-2-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b32d3ac9-f671-46bc-3653-08d75f16b1af
x-ms-traffictypediagnostic: VI1PR05MB3293:|VI1PR05MB3293:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB32938E26639E74BD0310CB8FBE620@VI1PR05MB3293.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(199004)(189003)(4326008)(66066001)(6306002)(6116002)(3846002)(71190400001)(256004)(99286004)(107886003)(54906003)(14454004)(76176011)(6512007)(478600001)(14444005)(316002)(966005)(71200400001)(6506007)(1076003)(52116002)(36756003)(386003)(2906002)(66946007)(66556008)(6436002)(50226002)(7736002)(6486002)(66476007)(6916009)(305945005)(186003)(64756008)(81156014)(81166006)(486006)(8676002)(25786009)(476003)(11346002)(446003)(2616005)(5660300002)(26005)(86362001)(102836004)(66446008)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3293;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g2gsMDVy2XhuiZ/UOunQkOb8AJdVPkecGouWKDPSgnNszpQQor4VavD0IH2r9aFIft7PWmq/s/KvPSR2sP/yI4iKOXMETsTpLMofwBtjSdYZdVij7XILs9IIGuwHprzz2OvhNLEmPi1xyUz+SjKiJRY+pODvbRJ2b47H4BJJ6YyW/xiM2thm+asTvr+S/I9KDXrza2puWLFFIIp0BqQjksru7j2ivKqfBuD9kEfjMtMwmMpocLpuAI/dXtl4JqnLqoyJnHE+lFnClpu9yaNKfeII6QiiIrgMHITPmAPTKoLpIu/36XrDCsWNXU6HvvNIyryNW57XgvWc+bSRD8x4z/HaTLqyrFcklsPmKIfSqX9qZEwuKl7YFXJAWAMcjMS4u+2Hj0/i8LCywNu+0jrw+Ov6+Hw6Pm469xjl9QpDjsP8dfuRqCnBl1P0aD/gi9bHZObL/DfN/iNb5LDAEaTKFuOEBS8afy2/Yaar2wLt0l0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32d3ac9-f671-46bc-3653-08d75f16b1af
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:58:57.2842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 50N8J75sIET5sJaX9imPqJMQNBqhc3ecR4cbTWtng9CkeW2ZDifyABsvNvwB4EXA/qKJo5xf19XutInwenpzKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3293
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hamdan Igbaria <hamdani@mellanox.com>

Use kernel function to calculate crc32 Instead of dr implementation
since it has the same algorithm "slice by 8".

Fixes: 26d688e33f88 ("net/mlx5: DR, Add Steering entry (STE) utilities")
Signed-off-by: Hamdan Igbaria <hamdani@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../mellanox/mlx5/core/steering/dr_crc32.c    | 98 -------------------
 .../mellanox/mlx5/core/steering/dr_domain.c   |  3 -
 .../mellanox/mlx5/core/steering/dr_ste.c      | 10 +-
 .../mellanox/mlx5/core/steering/dr_types.h    |  3 -
 5 files changed, 10 insertions(+), 106 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_crc=
32.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index 5708fcc079ca..a6f390fdb971 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -70,7 +70,7 @@ mlx5_core-$(CONFIG_MLX5_EN_TLS) +=3D en_accel/tls.o en_ac=
cel/tls_rxtx.o en_accel/t
=20
 mlx5_core-$(CONFIG_MLX5_SW_STEERING) +=3D steering/dr_domain.o steering/dr=
_table.o \
 					steering/dr_matcher.o steering/dr_rule.o \
-					steering/dr_icm_pool.o steering/dr_crc32.o \
+					steering/dr_icm_pool.o \
 					steering/dr_ste.o steering/dr_send.o \
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_crc32.c b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_crc32.c
deleted file mode 100644
index 9e2eccbb1eb8..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_crc32.c
+++ /dev/null
@@ -1,98 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
-/* Copyright (c) 2019 Mellanox Technologies. */
-
-/* Copyright (c) 2011-2015 Stephan Brumme. All rights reserved.
- * Slicing-by-16 contributed by Bulat Ziganshin
- *
- * This software is provided 'as-is', without any express or implied warra=
nty.
- * In no event will the author be held liable for any damages arising from=
 the
- * of this software.
- *
- * Permission is granted to anyone to use this software for any purpose,
- * including commercial applications, and to alter it and redistribute it
- * freely, subject to the following restrictions:
- *
- * 1. The origin of this software must not be misrepresented; you must not
- *    claim that you wrote the original software.
- * 2. If you use this software in a product, an acknowledgment in the prod=
uct
- *    documentation would be appreciated but is not required.
- * 3. Altered source versions must be plainly marked as such, and must not=
 be
- *    misrepresented as being the original software.
- *
- * Taken from http://create.stephan-brumme.com/crc32/ and adapted.
- */
-
-#include "dr_types.h"
-
-#define DR_STE_CRC_POLY 0xEDB88320L
-
-static u32 dr_ste_crc_tab32[8][256];
-
-static void dr_crc32_calc_lookup_entry(u32 (*tbl)[256], u8 i, u8 j)
-{
-	tbl[i][j] =3D (tbl[i - 1][j] >> 8) ^ tbl[0][tbl[i - 1][j] & 0xff];
-}
-
-void mlx5dr_crc32_init_table(void)
-{
-	u32 crc, i, j;
-
-	for (i =3D 0; i < 256; i++) {
-		crc =3D i;
-		for (j =3D 0; j < 8; j++) {
-			if (crc & 0x00000001L)
-				crc =3D (crc >> 1) ^ DR_STE_CRC_POLY;
-			else
-				crc =3D crc >> 1;
-		}
-		dr_ste_crc_tab32[0][i] =3D crc;
-	}
-
-	/* Init CRC lookup tables according to crc_slice_8 algorithm */
-	for (i =3D 0; i < 256; i++) {
-		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 1, i);
-		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 2, i);
-		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 3, i);
-		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 4, i);
-		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 5, i);
-		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 6, i);
-		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 7, i);
-	}
-}
-
-/* Compute CRC32 (Slicing-by-8 algorithm) */
-u32 mlx5dr_crc32_slice8_calc(const void *input_data, size_t length)
-{
-	const u32 *curr =3D (const u32 *)input_data;
-	const u8 *curr_char;
-	u32 crc =3D 0, one, two;
-
-	if (!input_data)
-		return 0;
-
-	/* Process eight bytes at once (Slicing-by-8) */
-	while (length >=3D 8) {
-		one =3D *curr++ ^ crc;
-		two =3D *curr++;
-
-		crc =3D dr_ste_crc_tab32[0][(two >> 24) & 0xff]
-			^ dr_ste_crc_tab32[1][(two >> 16) & 0xff]
-			^ dr_ste_crc_tab32[2][(two >> 8) & 0xff]
-			^ dr_ste_crc_tab32[3][two & 0xff]
-			^ dr_ste_crc_tab32[4][(one >> 24) & 0xff]
-			^ dr_ste_crc_tab32[5][(one >> 16) & 0xff]
-			^ dr_ste_crc_tab32[6][(one >> 8) & 0xff]
-			^ dr_ste_crc_tab32[7][one & 0xff];
-
-		length -=3D 8;
-	}
-
-	curr_char =3D (const u8 *)curr;
-	/* Remaining 1 to 7 bytes (standard algorithm) */
-	while (length-- !=3D 0)
-		crc =3D (crc >> 8) ^ dr_ste_crc_tab32[0][(crc & 0xff)
-			^ *curr_char++];
-
-	return ((crc >> 24) & 0xff) | ((crc << 8) & 0xff0000) |
-		((crc >> 8) & 0xff00) | ((crc << 24) & 0xff000000);
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 5b24732b18c0..a9da961d4d2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -326,9 +326,6 @@ mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum m=
lx5dr_domain_type type)
 		goto uninit_resourses;
 	}
=20
-	/* Init CRC table for htbl CRC calculation */
-	mlx5dr_crc32_init_table();
-
 	return dmn;
=20
 uninit_resourses:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 4efe1b0be4a8..7e9d6cfc356f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
=20
 #include <linux/types.h>
+#include <linux/crc32.h>
 #include "dr_types.h"
=20
 #define DR_STE_CRC_POLY 0xEDB88320L
@@ -107,6 +108,13 @@ struct dr_hw_ste_format {
 	u8 mask[DR_STE_SIZE_MASK];
 };
=20
+static u32 dr_ste_crc32_calc(const void *input_data, size_t length)
+{
+	u32 crc =3D crc32(0, input_data, length);
+
+	return htonl(crc);
+}
+
 u32 mlx5dr_ste_calc_hash_index(u8 *hw_ste_p, struct mlx5dr_ste_htbl *htbl)
 {
 	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
@@ -128,7 +136,7 @@ u32 mlx5dr_ste_calc_hash_index(u8 *hw_ste_p, struct mlx=
5dr_ste_htbl *htbl)
 		bit =3D bit >> 1;
 	}
=20
-	crc32 =3D mlx5dr_crc32_slice8_calc(masked, DR_STE_SIZE_TAG);
+	crc32 =3D dr_ste_crc32_calc(masked, DR_STE_SIZE_TAG);
 	index =3D crc32 & (htbl->chunk->num_of_entries - 1);
=20
 	return index;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 1cb3769d4e3c..d6d9bc5f4adf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -962,9 +962,6 @@ void mlx5dr_ste_copy_param(u8 match_criteria,
 			   struct mlx5dr_match_param *set_param,
 			   struct mlx5dr_match_parameters *mask);
=20
-void mlx5dr_crc32_init_table(void);
-u32 mlx5dr_crc32_slice8_calc(const void *input_data, size_t length);
-
 struct mlx5dr_qp {
 	struct mlx5_core_dev *mdev;
 	struct mlx5_wq_qp wq;
--=20
2.21.0

