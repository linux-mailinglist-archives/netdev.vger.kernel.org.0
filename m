Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5DCA7434
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfICUFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:05:25 -0400
Received: from mail-eopbgr140051.outbound.protection.outlook.com ([40.107.14.51]:21316
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726085AbfICUFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:05:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fM+FFx73LW1K7geXVLN/mUP53yBYre3ZRTc08EkPWxWlCM9DDM7V7FF+sSw8CE5zsDsTfwpzMreTHrDGiBK7S+h/IkfTWL9xs+dqB6NkVIIZOfFybKTrHTMwiO1AKi3V9kIvyNpuFgvpXWo2fqF/gbOxcp9Pvui4af4H0vlsz0TMloeacReSbE0U6Z90K6WMXqEJvZWFF//2QsqvUOVIBZe1zgzhwrPplp679ktexCO7Jc9XU9TVu8MJ5ijs1Oq/GC0ZhoPMHGe85xRWZSgG/pO4UsU04RIC8Za8kTYmm/cLfKsaf6ZCl+8SfJv3kqtsIyj9uW2jW6YmJBRb83lYDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KGCiOtPQ7vXhNWYo2As7TUL3aELie4NipFxlSNSM9c=;
 b=m9NNafk8j/cSsw1N9jJCu1fEthTzeIla90m2BO3t+bpdGTL5y2gXEev0M6OtIRXpw8AnEoHesypgk4Ui7ZmB16TwQXUbMdJp3sRCRYQztHZaZCknLq2A5p8L4AKhF+CBSc5523xSumtemzFWw5IAJmHWwBCItb+vnuUIIZqNoIpGqB4iquMy0seVUfplNV+36ZtdSoxF67I6Uic/kPY/iDmdl5btZi9DZAzKXTplPFBhd8YAa0rzPXjr4nmbvoOu10UiwtdZeyk+eyqelZfH+ci890yKWOoeY3tDe0mAuXDzORCgNX2CtKudOSsIic1o099+L4zTO0hroa+uDAqOOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KGCiOtPQ7vXhNWYo2As7TUL3aELie4NipFxlSNSM9c=;
 b=s9tpNVT6rxcYAZHYHYhvDuyxroqb9+DpXD7L03sdUJy1CzUu/WzqZuUERUYgPwoj4/06x83f/JlPhDH4/wSdjZYTk0ZfnHmPlE00ucyuJbrxSxC6TaiPA44CGel8AMIrnu7f0NRDUGsiKy+ZT0UNMylJVzNFezwWzYZRHwVvc6w=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2706.eurprd05.prod.outlook.com (10.172.221.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Tue, 3 Sep 2019 20:04:39 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 20:04:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 06/18] net/mlx5: DR, Add Steering entry (STE) utilities
Thread-Topic: [net-next V2 06/18] net/mlx5: DR, Add Steering entry (STE)
 utilities
Thread-Index: AQHVYpLRWQVG9y5paECB1XD5p4iMxA==
Date:   Tue, 3 Sep 2019 20:04:39 +0000
Message-ID: <20190903200409.14406-7-saeedm@mellanox.com>
References: <20190903200409.14406-1-saeedm@mellanox.com>
In-Reply-To: <20190903200409.14406-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:a03:54::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b04875ce-3653-473b-3710-08d730a9f38a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2706;
x-ms-traffictypediagnostic: AM4PR0501MB2706:|AM4PR0501MB2706:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB27065D469016C8F983360BBBBEB90@AM4PR0501MB2706.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(199004)(189003)(2906002)(102836004)(256004)(26005)(11346002)(50226002)(186003)(66446008)(386003)(6506007)(64756008)(66556008)(14444005)(66476007)(71190400001)(66946007)(2616005)(476003)(76176011)(71200400001)(5660300002)(8936002)(66066001)(446003)(81166006)(81156014)(30864003)(6306002)(478600001)(54906003)(6916009)(966005)(8676002)(486006)(36756003)(3846002)(7736002)(53936002)(6436002)(305945005)(53946003)(14454004)(6116002)(52116002)(6512007)(86362001)(316002)(99286004)(1076003)(6486002)(4326008)(107886003)(25786009)(579004)(559001)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2706;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FUXXHH9gSb5QHK4lS3++dN3A67uIm9yO/ZrwwWkpZ45pgEwvC8DRBiG0znBIyqcHjeq0BTn8KccyYHqJPJRD2TverQ+5UxernJzEiZd28zHHsvA3LgUeNrgwFduJu82EJ64e6jtHlcpVZMkwscBxMQ+NseXGz3Gvc8NcRy2A/W6G6RojhVFxHAHNa0c3wO5maStEa8V3JNSz/d8e9q9nnjFefnp8ZiORpfE6QiWBjvXRmXcN6cGw14u8yRw1vxamSP0VaPZotBT09LC7xGMuMMvT/fEW0W/zJJ3WOpXLmtRooXOHkjykuvxD0ndx/FjLYcGCBCf31LlZwWXqbfXOouflxVcGTt5cWjv1y9M/gihKW81MUAQMCU9ALv9QD9VsXJCFi+AOTbBr9zhyy093+u0HU7Hsm7Cb1b3f8oqyCq4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b04875ce-3653-473b-3710-08d730a9f38a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 20:04:39.4380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ++Mw3l1EV4YJjLl3veYF3mcV91Pd8Fi43K4bRD/an3FxYF88fLi7JFmls0BiPEb4eRpMKxtS/5vFrufIqQcHhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2706
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Steering Entry (STE) object is the basic building block of the steering
map. There are several types of STEs. Each rule can be constructed of
multiple STEs. Each STE dictates which fields of the packet's header are
being matched as well as the information about the next step in map (hit
and miss pointers). The hardware gets a packet and tries to match it
against the STEs, going to either the hit pointer or the miss pointer.
This file handles the STE operations.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_crc32.c    |   98 +
 .../mellanox/mlx5/core/steering/dr_ste.c      | 2308 +++++++++++++++++
 2 files changed, 2406 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_crc=
32.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste=
.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_crc32.c b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_crc32.c
new file mode 100644
index 000000000000..9e2eccbb1eb8
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_crc32.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+/* Copyright (c) 2011-2015 Stephan Brumme. All rights reserved.
+ * Slicing-by-16 contributed by Bulat Ziganshin
+ *
+ * This software is provided 'as-is', without any express or implied warra=
nty.
+ * In no event will the author be held liable for any damages arising from=
 the
+ * of this software.
+ *
+ * Permission is granted to anyone to use this software for any purpose,
+ * including commercial applications, and to alter it and redistribute it
+ * freely, subject to the following restrictions:
+ *
+ * 1. The origin of this software must not be misrepresented; you must not
+ *    claim that you wrote the original software.
+ * 2. If you use this software in a product, an acknowledgment in the prod=
uct
+ *    documentation would be appreciated but is not required.
+ * 3. Altered source versions must be plainly marked as such, and must not=
 be
+ *    misrepresented as being the original software.
+ *
+ * Taken from http://create.stephan-brumme.com/crc32/ and adapted.
+ */
+
+#include "dr_types.h"
+
+#define DR_STE_CRC_POLY 0xEDB88320L
+
+static u32 dr_ste_crc_tab32[8][256];
+
+static void dr_crc32_calc_lookup_entry(u32 (*tbl)[256], u8 i, u8 j)
+{
+	tbl[i][j] =3D (tbl[i - 1][j] >> 8) ^ tbl[0][tbl[i - 1][j] & 0xff];
+}
+
+void mlx5dr_crc32_init_table(void)
+{
+	u32 crc, i, j;
+
+	for (i =3D 0; i < 256; i++) {
+		crc =3D i;
+		for (j =3D 0; j < 8; j++) {
+			if (crc & 0x00000001L)
+				crc =3D (crc >> 1) ^ DR_STE_CRC_POLY;
+			else
+				crc =3D crc >> 1;
+		}
+		dr_ste_crc_tab32[0][i] =3D crc;
+	}
+
+	/* Init CRC lookup tables according to crc_slice_8 algorithm */
+	for (i =3D 0; i < 256; i++) {
+		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 1, i);
+		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 2, i);
+		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 3, i);
+		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 4, i);
+		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 5, i);
+		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 6, i);
+		dr_crc32_calc_lookup_entry(dr_ste_crc_tab32, 7, i);
+	}
+}
+
+/* Compute CRC32 (Slicing-by-8 algorithm) */
+u32 mlx5dr_crc32_slice8_calc(const void *input_data, size_t length)
+{
+	const u32 *curr =3D (const u32 *)input_data;
+	const u8 *curr_char;
+	u32 crc =3D 0, one, two;
+
+	if (!input_data)
+		return 0;
+
+	/* Process eight bytes at once (Slicing-by-8) */
+	while (length >=3D 8) {
+		one =3D *curr++ ^ crc;
+		two =3D *curr++;
+
+		crc =3D dr_ste_crc_tab32[0][(two >> 24) & 0xff]
+			^ dr_ste_crc_tab32[1][(two >> 16) & 0xff]
+			^ dr_ste_crc_tab32[2][(two >> 8) & 0xff]
+			^ dr_ste_crc_tab32[3][two & 0xff]
+			^ dr_ste_crc_tab32[4][(one >> 24) & 0xff]
+			^ dr_ste_crc_tab32[5][(one >> 16) & 0xff]
+			^ dr_ste_crc_tab32[6][(one >> 8) & 0xff]
+			^ dr_ste_crc_tab32[7][one & 0xff];
+
+		length -=3D 8;
+	}
+
+	curr_char =3D (const u8 *)curr;
+	/* Remaining 1 to 7 bytes (standard algorithm) */
+	while (length-- !=3D 0)
+		crc =3D (crc >> 8) ^ dr_ste_crc_tab32[0][(crc & 0xff)
+			^ *curr_char++];
+
+	return ((crc >> 24) & 0xff) | ((crc << 8) & 0xff0000) |
+		((crc >> 8) & 0xff00) | ((crc << 24) & 0xff000000);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
new file mode 100644
index 000000000000..6b0af64536d8
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -0,0 +1,2308 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include <linux/types.h>
+#include "dr_types.h"
+
+#define DR_STE_CRC_POLY 0xEDB88320L
+#define STE_IPV4 0x1
+#define STE_IPV6 0x2
+#define STE_TCP 0x1
+#define STE_UDP 0x2
+#define STE_SPI 0x3
+#define IP_VERSION_IPV4 0x4
+#define IP_VERSION_IPV6 0x6
+#define STE_SVLAN 0x1
+#define STE_CVLAN 0x2
+
+#define DR_STE_ENABLE_FLOW_TAG BIT(31)
+
+/* Set to STE a specific value using DR_STE_SET */
+#define DR_STE_SET_VAL(lookup_type, tag, t_fname, spec, s_fname, value) do=
 { \
+	if ((spec)->s_fname) { \
+		MLX5_SET(ste_##lookup_type, tag, t_fname, value); \
+		(spec)->s_fname =3D 0; \
+	} \
+} while (0)
+
+/* Set to STE spec->s_fname to tag->t_fname */
+#define DR_STE_SET_TAG(lookup_type, tag, t_fname, spec, s_fname) \
+	DR_STE_SET_VAL(lookup_type, tag, t_fname, spec, s_fname, spec->s_fname)
+
+/* Set to STE -1 to bit_mask->bm_fname and set spec->s_fname as used */
+#define DR_STE_SET_MASK(lookup_type, bit_mask, bm_fname, spec, s_fname) \
+	DR_STE_SET_VAL(lookup_type, bit_mask, bm_fname, spec, s_fname, -1)
+
+/* Set to STE spec->s_fname to bit_mask->bm_fname and set spec->s_fname as=
 used */
+#define DR_STE_SET_MASK_V(lookup_type, bit_mask, bm_fname, spec, s_fname) =
\
+	DR_STE_SET_VAL(lookup_type, bit_mask, bm_fname, spec, s_fname, (spec)->s_=
fname)
+
+#define DR_STE_SET_TCP_FLAGS(lookup_type, tag, spec) do { \
+	MLX5_SET(ste_##lookup_type, tag, tcp_ns, !!((spec)->tcp_flags & (1 << 8))=
); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_cwr, !!((spec)->tcp_flags & (1 << 7)=
)); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_ece, !!((spec)->tcp_flags & (1 << 6)=
)); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_urg, !!((spec)->tcp_flags & (1 << 5)=
)); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_ack, !!((spec)->tcp_flags & (1 << 4)=
)); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_psh, !!((spec)->tcp_flags & (1 << 3)=
)); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_rst, !!((spec)->tcp_flags & (1 << 2)=
)); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_syn, !!((spec)->tcp_flags & (1 << 1)=
)); \
+	MLX5_SET(ste_##lookup_type, tag, tcp_fin, !!((spec)->tcp_flags & (1 << 0)=
)); \
+} while (0)
+
+#define DR_STE_SET_MPLS_MASK(lookup_type, mask, in_out, bit_mask) do { \
+	DR_STE_SET_MASK_V(lookup_type, mask, mpls0_label, mask, \
+			  in_out##_first_mpls_label);\
+	DR_STE_SET_MASK_V(lookup_type, mask, mpls0_s_bos, mask, \
+			  in_out##_first_mpls_s_bos); \
+	DR_STE_SET_MASK_V(lookup_type, mask, mpls0_exp, mask, \
+			  in_out##_first_mpls_exp); \
+	DR_STE_SET_MASK_V(lookup_type, mask, mpls0_ttl, mask, \
+			  in_out##_first_mpls_ttl); \
+} while (0)
+
+#define DR_STE_SET_MPLS_TAG(lookup_type, mask, in_out, tag) do { \
+	DR_STE_SET_TAG(lookup_type, tag, mpls0_label, mask, \
+		       in_out##_first_mpls_label);\
+	DR_STE_SET_TAG(lookup_type, tag, mpls0_s_bos, mask, \
+		       in_out##_first_mpls_s_bos); \
+	DR_STE_SET_TAG(lookup_type, tag, mpls0_exp, mask, \
+		       in_out##_first_mpls_exp); \
+	DR_STE_SET_TAG(lookup_type, tag, mpls0_ttl, mask, \
+		       in_out##_first_mpls_ttl); \
+} while (0)
+
+#define DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(_misc) (\
+	(_misc)->outer_first_mpls_over_gre_label || \
+	(_misc)->outer_first_mpls_over_gre_exp || \
+	(_misc)->outer_first_mpls_over_gre_s_bos || \
+	(_misc)->outer_first_mpls_over_gre_ttl)
+#define DR_STE_IS_OUTER_MPLS_OVER_UDP_SET(_misc) (\
+	(_misc)->outer_first_mpls_over_udp_label || \
+	(_misc)->outer_first_mpls_over_udp_exp || \
+	(_misc)->outer_first_mpls_over_udp_s_bos || \
+	(_misc)->outer_first_mpls_over_udp_ttl)
+
+#define DR_STE_CALC_LU_TYPE(lookup_type, rx, inner) \
+	((inner) ? MLX5DR_STE_LU_TYPE_##lookup_type##_I : \
+		   (rx) ? MLX5DR_STE_LU_TYPE_##lookup_type##_D : \
+			  MLX5DR_STE_LU_TYPE_##lookup_type##_O)
+
+enum dr_ste_tunl_action {
+	DR_STE_TUNL_ACTION_NONE		=3D 0,
+	DR_STE_TUNL_ACTION_ENABLE	=3D 1,
+	DR_STE_TUNL_ACTION_DECAP	=3D 2,
+	DR_STE_TUNL_ACTION_L3_DECAP	=3D 3,
+	DR_STE_TUNL_ACTION_POP_VLAN	=3D 4,
+};
+
+enum dr_ste_action_type {
+	DR_STE_ACTION_TYPE_PUSH_VLAN	=3D 1,
+	DR_STE_ACTION_TYPE_ENCAP_L3	=3D 3,
+	DR_STE_ACTION_TYPE_ENCAP	=3D 4,
+};
+
+struct dr_hw_ste_format {
+	u8 ctrl[DR_STE_SIZE_CTRL];
+	u8 tag[DR_STE_SIZE_TAG];
+	u8 mask[DR_STE_SIZE_MASK];
+};
+
+u32 mlx5dr_ste_calc_hash_index(u8 *hw_ste_p, struct mlx5dr_ste_htbl *htbl)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	u8 masked[DR_STE_SIZE_TAG] =3D {};
+	u32 crc32, index;
+	u16 bit;
+	int i;
+
+	/* Don't calculate CRC if the result is predicted */
+	if (htbl->chunk->num_of_entries =3D=3D 1 || htbl->byte_mask =3D=3D 0)
+		return 0;
+
+	/* Mask tag using byte mask, bit per byte */
+	bit =3D 1 << (DR_STE_SIZE_TAG - 1);
+	for (i =3D 0; i < DR_STE_SIZE_TAG; i++) {
+		if (htbl->byte_mask & bit)
+			masked[i] =3D hw_ste->tag[i];
+
+		bit =3D bit >> 1;
+	}
+
+	crc32 =3D mlx5dr_crc32_slice8_calc(masked, DR_STE_SIZE_TAG);
+	index =3D crc32 & (htbl->chunk->num_of_entries - 1);
+
+	return index;
+}
+
+static u16 dr_ste_conv_bit_to_byte_mask(u8 *bit_mask)
+{
+	u16 byte_mask =3D 0;
+	int i;
+
+	for (i =3D 0; i < DR_STE_SIZE_MASK; i++) {
+		byte_mask =3D byte_mask << 1;
+		if (bit_mask[i] =3D=3D 0xff)
+			byte_mask |=3D 1;
+	}
+	return byte_mask;
+}
+
+void mlx5dr_ste_set_bit_mask(u8 *hw_ste_p, u8 *bit_mask)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+
+	memcpy(hw_ste->mask, bit_mask, DR_STE_SIZE_MASK);
+}
+
+void mlx5dr_ste_rx_set_flow_tag(u8 *hw_ste_p, u32 flow_tag)
+{
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, qp_list_pointer,
+		 DR_STE_ENABLE_FLOW_TAG | flow_tag);
+}
+
+void mlx5dr_ste_set_counter_id(u8 *hw_ste_p, u32 ctr_id)
+{
+	/* This can be used for both rx_steering_mult and for sx_transmit */
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, counter_trigger_15_0, ctr_id);
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, counter_trigger_23_16, ctr_id >>=
 16);
+}
+
+void mlx5dr_ste_set_go_back_bit(u8 *hw_ste_p)
+{
+	MLX5_SET(ste_sx_transmit, hw_ste_p, go_back, 1);
+}
+
+void mlx5dr_ste_set_tx_push_vlan(u8 *hw_ste_p, u32 vlan_hdr,
+				 bool go_back)
+{
+	MLX5_SET(ste_sx_transmit, hw_ste_p, action_type,
+		 DR_STE_ACTION_TYPE_PUSH_VLAN);
+	MLX5_SET(ste_sx_transmit, hw_ste_p, encap_pointer_vlan_data, vlan_hdr);
+	/* Due to HW limitation we need to set this bit, otherwise reforamt +
+	 * push vlan will not work.
+	 */
+	if (go_back)
+		mlx5dr_ste_set_go_back_bit(hw_ste_p);
+}
+
+void mlx5dr_ste_set_tx_encap(void *hw_ste_p, u32 reformat_id, int size, bo=
ol encap_l3)
+{
+	MLX5_SET(ste_sx_transmit, hw_ste_p, action_type,
+		 encap_l3 ? DR_STE_ACTION_TYPE_ENCAP_L3 : DR_STE_ACTION_TYPE_ENCAP);
+	/* The hardware expects here size in words (2 byte) */
+	MLX5_SET(ste_sx_transmit, hw_ste_p, action_description, size / 2);
+	MLX5_SET(ste_sx_transmit, hw_ste_p, encap_pointer_vlan_data, reformat_id)=
;
+}
+
+void mlx5dr_ste_set_rx_decap(u8 *hw_ste_p)
+{
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
+		 DR_STE_TUNL_ACTION_DECAP);
+}
+
+void mlx5dr_ste_set_rx_pop_vlan(u8 *hw_ste_p)
+{
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
+		 DR_STE_TUNL_ACTION_POP_VLAN);
+}
+
+void mlx5dr_ste_set_rx_decap_l3(u8 *hw_ste_p, bool vlan)
+{
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
+		 DR_STE_TUNL_ACTION_L3_DECAP);
+	MLX5_SET(ste_modify_packet, hw_ste_p, action_description, vlan ? 1 : 0);
+}
+
+void mlx5dr_ste_set_entry_type(u8 *hw_ste_p, u8 entry_type)
+{
+	MLX5_SET(ste_general, hw_ste_p, entry_type, entry_type);
+}
+
+u8 mlx5dr_ste_get_entry_type(u8 *hw_ste_p)
+{
+	return MLX5_GET(ste_general, hw_ste_p, entry_type);
+}
+
+void mlx5dr_ste_set_rewrite_actions(u8 *hw_ste_p, u16 num_of_actions,
+				    u32 re_write_index)
+{
+	MLX5_SET(ste_modify_packet, hw_ste_p, number_of_re_write_actions,
+		 num_of_actions);
+	MLX5_SET(ste_modify_packet, hw_ste_p, header_re_write_actions_pointer,
+		 re_write_index);
+}
+
+void mlx5dr_ste_set_hit_gvmi(u8 *hw_ste_p, u16 gvmi)
+{
+	MLX5_SET(ste_general, hw_ste_p, next_table_base_63_48, gvmi);
+}
+
+void mlx5dr_ste_init(u8 *hw_ste_p, u8 lu_type, u8 entry_type,
+		     u16 gvmi)
+{
+	MLX5_SET(ste_general, hw_ste_p, entry_type, entry_type);
+	MLX5_SET(ste_general, hw_ste_p, entry_sub_type, lu_type);
+	MLX5_SET(ste_general, hw_ste_p, next_lu_type, MLX5DR_STE_LU_TYPE_DONT_CAR=
E);
+
+	/* Set GVMI once, this is the same for RX/TX
+	 * bits 63_48 of next table base / miss address encode the next GVMI
+	 */
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, gvmi, gvmi);
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, next_table_base_63_48, gvmi);
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_63_48, gvmi);
+}
+
+static void dr_ste_set_always_hit(struct dr_hw_ste_format *hw_ste)
+{
+	memset(&hw_ste->tag, 0, sizeof(hw_ste->tag));
+	memset(&hw_ste->mask, 0, sizeof(hw_ste->mask));
+}
+
+static void dr_ste_set_always_miss(struct dr_hw_ste_format *hw_ste)
+{
+	hw_ste->tag[0] =3D 0xdc;
+	hw_ste->mask[0] =3D 0;
+}
+
+u64 mlx5dr_ste_get_miss_addr(u8 *hw_ste)
+{
+	u64 index =3D
+		(MLX5_GET(ste_rx_steering_mult, hw_ste, miss_address_31_6) |
+		 MLX5_GET(ste_rx_steering_mult, hw_ste, miss_address_39_32) << 26);
+
+	return index << 6;
+}
+
+void mlx5dr_ste_set_hit_addr(u8 *hw_ste, u64 icm_addr, u32 ht_size)
+{
+	u64 index =3D (icm_addr >> 5) | ht_size;
+
+	MLX5_SET(ste_general, hw_ste, next_table_base_39_32_size, index >> 27);
+	MLX5_SET(ste_general, hw_ste, next_table_base_31_5_size, index);
+}
+
+u64 mlx5dr_ste_get_icm_addr(struct mlx5dr_ste *ste)
+{
+	u32 index =3D ste - ste->htbl->ste_arr;
+
+	return ste->htbl->chunk->icm_addr + DR_STE_SIZE * index;
+}
+
+u64 mlx5dr_ste_get_mr_addr(struct mlx5dr_ste *ste)
+{
+	u32 index =3D ste - ste->htbl->ste_arr;
+
+	return ste->htbl->chunk->mr_addr + DR_STE_SIZE * index;
+}
+
+struct list_head *mlx5dr_ste_get_miss_list(struct mlx5dr_ste *ste)
+{
+	u32 index =3D ste - ste->htbl->ste_arr;
+
+	return &ste->htbl->miss_list[index];
+}
+
+static void dr_ste_always_hit_htbl(struct mlx5dr_ste *ste,
+				   struct mlx5dr_ste_htbl *next_htbl)
+{
+	struct mlx5dr_icm_chunk *chunk =3D next_htbl->chunk;
+	u8 *hw_ste =3D ste->hw_ste;
+
+	MLX5_SET(ste_general, hw_ste, byte_mask, next_htbl->byte_mask);
+	MLX5_SET(ste_general, hw_ste, next_lu_type, next_htbl->lu_type);
+	mlx5dr_ste_set_hit_addr(hw_ste, chunk->icm_addr, chunk->num_of_entries);
+
+	dr_ste_set_always_hit((struct dr_hw_ste_format *)ste->hw_ste);
+}
+
+bool mlx5dr_ste_is_last_in_rule(struct mlx5dr_matcher_rx_tx *nic_matcher,
+				u8 ste_location)
+{
+	return ste_location =3D=3D nic_matcher->num_of_builders;
+}
+
+/* Replace relevant fields, except of:
+ * htbl - keep the origin htbl
+ * miss_list + list - already took the src from the list.
+ * icm_addr/mr_addr - depends on the hosting table.
+ *
+ * Before:
+ * | a | -> | b | -> | c | ->
+ *
+ * After:
+ * | a | -> | c | ->
+ * While the data that was in b copied to a.
+ */
+static void dr_ste_replace(struct mlx5dr_ste *dst, struct mlx5dr_ste *src)
+{
+	memcpy(dst->hw_ste, src->hw_ste, DR_STE_SIZE_REDUCED);
+	dst->next_htbl =3D src->next_htbl;
+	if (dst->next_htbl)
+		dst->next_htbl->pointing_ste =3D dst;
+
+	refcount_set(&dst->refcount, refcount_read(&src->refcount));
+
+	INIT_LIST_HEAD(&dst->rule_list);
+	list_splice_tail_init(&src->rule_list, &dst->rule_list);
+}
+
+/* Free ste which is the head and the only one in miss_list */
+static void
+dr_ste_remove_head_ste(struct mlx5dr_ste *ste,
+		       struct mlx5dr_matcher_rx_tx *nic_matcher,
+		       struct mlx5dr_ste_send_info *ste_info_head,
+		       struct list_head *send_ste_list,
+		       struct mlx5dr_ste_htbl *stats_tbl)
+{
+	u8 tmp_data_ste[DR_STE_SIZE] =3D {};
+	struct mlx5dr_ste tmp_ste =3D {};
+	u64 miss_addr;
+
+	tmp_ste.hw_ste =3D tmp_data_ste;
+
+	/* Use temp ste because dr_ste_always_miss_addr
+	 * touches bit_mask area which doesn't exist at ste->hw_ste.
+	 */
+	memcpy(tmp_ste.hw_ste, ste->hw_ste, DR_STE_SIZE_REDUCED);
+	miss_addr =3D nic_matcher->e_anchor->chunk->icm_addr;
+	mlx5dr_ste_always_miss_addr(&tmp_ste, miss_addr);
+	memcpy(ste->hw_ste, tmp_ste.hw_ste, DR_STE_SIZE_REDUCED);
+
+	list_del_init(&ste->miss_list_node);
+
+	/* Write full STE size in order to have "always_miss" */
+	mlx5dr_send_fill_and_append_ste_send_info(ste, DR_STE_SIZE,
+						  0, tmp_data_ste,
+						  ste_info_head,
+						  send_ste_list,
+						  true /* Copy data */);
+
+	stats_tbl->ctrl.num_of_valid_entries--;
+}
+
+/* Free ste which is the head but NOT the only one in miss_list:
+ * |_ste_| --> |_next_ste_| -->|__| -->|__| -->/0
+ */
+static void
+dr_ste_replace_head_ste(struct mlx5dr_ste *ste, struct mlx5dr_ste *next_st=
e,
+			struct mlx5dr_ste_send_info *ste_info_head,
+			struct list_head *send_ste_list,
+			struct mlx5dr_ste_htbl *stats_tbl)
+
+{
+	struct mlx5dr_ste_htbl *next_miss_htbl;
+
+	next_miss_htbl =3D next_ste->htbl;
+
+	/* Remove from the miss_list the next_ste before copy */
+	list_del_init(&next_ste->miss_list_node);
+
+	/* All rule-members that use next_ste should know about that */
+	mlx5dr_rule_update_rule_member(next_ste, ste);
+
+	/* Move data from next into ste */
+	dr_ste_replace(ste, next_ste);
+
+	/* Del the htbl that contains the next_ste.
+	 * The origin htbl stay with the same number of entries.
+	 */
+	mlx5dr_htbl_put(next_miss_htbl);
+
+	mlx5dr_send_fill_and_append_ste_send_info(ste, DR_STE_SIZE_REDUCED,
+						  0, ste->hw_ste,
+						  ste_info_head,
+						  send_ste_list,
+						  true /* Copy data */);
+
+	stats_tbl->ctrl.num_of_collisions--;
+	stats_tbl->ctrl.num_of_valid_entries--;
+}
+
+/* Free ste that is located in the middle of the miss list:
+ * |__| -->|_prev_ste_|->|_ste_|-->|_next_ste_|
+ */
+static void dr_ste_remove_middle_ste(struct mlx5dr_ste *ste,
+				     struct mlx5dr_ste_send_info *ste_info,
+				     struct list_head *send_ste_list,
+				     struct mlx5dr_ste_htbl *stats_tbl)
+{
+	struct mlx5dr_ste *prev_ste;
+	u64 miss_addr;
+
+	prev_ste =3D list_entry(mlx5dr_ste_get_miss_list(ste)->prev, struct mlx5d=
r_ste,
+			      miss_list_node);
+	if (!prev_ste) {
+		WARN_ON(true);
+		return;
+	}
+
+	miss_addr =3D mlx5dr_ste_get_miss_addr(ste->hw_ste);
+	mlx5dr_ste_set_miss_addr(prev_ste->hw_ste, miss_addr);
+
+	mlx5dr_send_fill_and_append_ste_send_info(prev_ste, DR_STE_SIZE_REDUCED, =
0,
+						  prev_ste->hw_ste, ste_info,
+						  send_ste_list, true /* Copy data*/);
+
+	list_del_init(&ste->miss_list_node);
+
+	stats_tbl->ctrl.num_of_valid_entries--;
+	stats_tbl->ctrl.num_of_collisions--;
+}
+
+void mlx5dr_ste_free(struct mlx5dr_ste *ste,
+		     struct mlx5dr_matcher *matcher,
+		     struct mlx5dr_matcher_rx_tx *nic_matcher)
+{
+	struct mlx5dr_ste_send_info *cur_ste_info, *tmp_ste_info;
+	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
+	struct mlx5dr_ste_send_info ste_info_head;
+	struct mlx5dr_ste *next_ste, *first_ste;
+	bool put_on_origin_table =3D true;
+	struct mlx5dr_ste_htbl *stats_tbl;
+	LIST_HEAD(send_ste_list);
+
+	first_ste =3D list_entry(mlx5dr_ste_get_miss_list(ste)->next,
+			       struct mlx5dr_ste, miss_list_node);
+	stats_tbl =3D first_ste->htbl;
+
+	/* Two options:
+	 * 1. ste is head:
+	 *	a. head ste is the only ste in the miss list
+	 *	b. head ste is not the only ste in the miss-list
+	 * 2. ste is not head
+	 */
+	if (first_ste =3D=3D ste) { /* Ste is the head */
+		struct mlx5dr_ste *last_ste;
+
+		last_ste =3D list_last_entry(mlx5dr_ste_get_miss_list(ste),
+					   struct mlx5dr_ste, miss_list_node);
+		if (last_ste =3D=3D first_ste)
+			next_ste =3D NULL;
+		else
+			next_ste =3D list_entry(ste->miss_list_node.next,
+					      struct mlx5dr_ste, miss_list_node);
+
+		if (!next_ste) {
+			/* One and only entry in the list */
+			dr_ste_remove_head_ste(ste, nic_matcher,
+					       &ste_info_head,
+					       &send_ste_list,
+					       stats_tbl);
+		} else {
+			/* First but not only entry in the list */
+			dr_ste_replace_head_ste(ste, next_ste, &ste_info_head,
+						&send_ste_list, stats_tbl);
+			put_on_origin_table =3D false;
+		}
+	} else { /* Ste in the middle of the list */
+		dr_ste_remove_middle_ste(ste, &ste_info_head, &send_ste_list, stats_tbl)=
;
+	}
+
+	/* Update HW */
+	list_for_each_entry_safe(cur_ste_info, tmp_ste_info,
+				 &send_ste_list, send_list) {
+		list_del(&cur_ste_info->send_list);
+		mlx5dr_send_postsend_ste(dmn, cur_ste_info->ste,
+					 cur_ste_info->data, cur_ste_info->size,
+					 cur_ste_info->offset);
+	}
+
+	if (put_on_origin_table)
+		mlx5dr_htbl_put(ste->htbl);
+}
+
+bool mlx5dr_ste_equal_tag(void *src, void *dst)
+{
+	struct dr_hw_ste_format *s_hw_ste =3D (struct dr_hw_ste_format *)src;
+	struct dr_hw_ste_format *d_hw_ste =3D (struct dr_hw_ste_format *)dst;
+
+	return !memcmp(s_hw_ste->tag, d_hw_ste->tag, DR_STE_SIZE_TAG);
+}
+
+void mlx5dr_ste_set_hit_addr_by_next_htbl(u8 *hw_ste,
+					  struct mlx5dr_ste_htbl *next_htbl)
+{
+	struct mlx5dr_icm_chunk *chunk =3D next_htbl->chunk;
+
+	mlx5dr_ste_set_hit_addr(hw_ste, chunk->icm_addr, chunk->num_of_entries);
+}
+
+void mlx5dr_ste_set_miss_addr(u8 *hw_ste_p, u64 miss_addr)
+{
+	u64 index =3D miss_addr >> 6;
+
+	/* Miss address for TX and RX STEs located in the same offsets */
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_39_32, index >> 26)=
;
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_31_6, index);
+}
+
+void mlx5dr_ste_always_miss_addr(struct mlx5dr_ste *ste, u64 miss_addr)
+{
+	u8 *hw_ste =3D ste->hw_ste;
+
+	MLX5_SET(ste_rx_steering_mult, hw_ste, next_lu_type, MLX5DR_STE_LU_TYPE_D=
ONT_CARE);
+	mlx5dr_ste_set_miss_addr(hw_ste, miss_addr);
+	dr_ste_set_always_miss((struct dr_hw_ste_format *)ste->hw_ste);
+}
+
+/* The assumption here is that we don't update the ste->hw_ste if it is no=
t
+ * used ste, so it will be all zero, checking the next_lu_type.
+ */
+bool mlx5dr_ste_is_not_valid_entry(u8 *p_hw_ste)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)p_hw_ste;
+
+	if (MLX5_GET(ste_general, hw_ste, next_lu_type) =3D=3D
+	    MLX5DR_STE_LU_TYPE_NOP)
+		return true;
+
+	return false;
+}
+
+bool mlx5dr_ste_not_used_ste(struct mlx5dr_ste *ste)
+{
+	return !refcount_read(&ste->refcount);
+}
+
+static u16 get_bits_per_mask(u16 byte_mask)
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
+/* Init one ste as a pattern for ste data array */
+void mlx5dr_ste_set_formatted_ste(u16 gvmi,
+				  struct mlx5dr_domain_rx_tx *nic_dmn,
+				  struct mlx5dr_ste_htbl *htbl,
+				  u8 *formatted_ste,
+				  struct mlx5dr_htbl_connect_info *connect_info)
+{
+	struct mlx5dr_ste ste =3D {};
+
+	mlx5dr_ste_init(formatted_ste, htbl->lu_type, nic_dmn->ste_type, gvmi);
+	ste.hw_ste =3D formatted_ste;
+
+	if (connect_info->type =3D=3D CONNECT_HIT)
+		dr_ste_always_hit_htbl(&ste, connect_info->hit_next_htbl);
+	else
+		mlx5dr_ste_always_miss_addr(&ste, connect_info->miss_icm_addr);
+}
+
+int mlx5dr_ste_htbl_init_and_postsend(struct mlx5dr_domain *dmn,
+				      struct mlx5dr_domain_rx_tx *nic_dmn,
+				      struct mlx5dr_ste_htbl *htbl,
+				      struct mlx5dr_htbl_connect_info *connect_info,
+				      bool update_hw_ste)
+{
+	u8 formatted_ste[DR_STE_SIZE] =3D {};
+
+	mlx5dr_ste_set_formatted_ste(dmn->info.caps.gvmi,
+				     nic_dmn,
+				     htbl,
+				     formatted_ste,
+				     connect_info);
+
+	return mlx5dr_send_postsend_formatted_htbl(dmn, htbl, formatted_ste, upda=
te_hw_ste);
+}
+
+int mlx5dr_ste_create_next_htbl(struct mlx5dr_matcher *matcher,
+				struct mlx5dr_matcher_rx_tx *nic_matcher,
+				struct mlx5dr_ste *ste,
+				u8 *cur_hw_ste,
+				enum mlx5dr_icm_chunk_size log_table_size)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)cur_hw_ste=
;
+	struct mlx5dr_domain_rx_tx *nic_dmn =3D nic_matcher->nic_tbl->nic_dmn;
+	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
+	struct mlx5dr_htbl_connect_info info;
+	struct mlx5dr_ste_htbl *next_htbl;
+
+	if (!mlx5dr_ste_is_last_in_rule(nic_matcher, ste->ste_chain_location)) {
+		u32 bits_in_mask;
+		u8 next_lu_type;
+		u16 byte_mask;
+
+		next_lu_type =3D MLX5_GET(ste_general, hw_ste, next_lu_type);
+		byte_mask =3D MLX5_GET(ste_general, hw_ste, byte_mask);
+
+		/* Don't allocate table more than required,
+		 * the size of the table defined via the byte_mask, so no need
+		 * to allocate more than that.
+		 */
+		bits_in_mask =3D get_bits_per_mask(byte_mask) * BITS_PER_BYTE;
+		log_table_size =3D min(log_table_size, bits_in_mask);
+
+		next_htbl =3D mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
+						  log_table_size,
+						  next_lu_type,
+						  byte_mask);
+		if (!next_htbl) {
+			mlx5dr_dbg(dmn, "Failed allocating table\n");
+			return -ENOMEM;
+		}
+
+		/* Write new table to HW */
+		info.type =3D CONNECT_MISS;
+		info.miss_icm_addr =3D nic_matcher->e_anchor->chunk->icm_addr;
+		if (mlx5dr_ste_htbl_init_and_postsend(dmn, nic_dmn, next_htbl,
+						      &info, false)) {
+			mlx5dr_info(dmn, "Failed writing table to HW\n");
+			goto free_table;
+		}
+
+		mlx5dr_ste_set_hit_addr_by_next_htbl(cur_hw_ste, next_htbl);
+		ste->next_htbl =3D next_htbl;
+		next_htbl->pointing_ste =3D ste;
+	}
+
+	return 0;
+
+free_table:
+	mlx5dr_ste_htbl_free(next_htbl);
+	return -ENOENT;
+}
+
+static void dr_ste_set_ctrl(struct mlx5dr_ste_htbl *htbl)
+{
+	struct mlx5dr_ste_htbl_ctrl *ctrl =3D &htbl->ctrl;
+	int num_of_entries;
+
+	htbl->ctrl.may_grow =3D true;
+
+	if (htbl->chunk_size =3D=3D DR_CHUNK_SIZE_MAX - 1)
+		htbl->ctrl.may_grow =3D false;
+
+	/* Threshold is 50%, one is added to table of size 1 */
+	num_of_entries =3D mlx5dr_icm_pool_chunk_size_to_entries(htbl->chunk_size=
);
+	ctrl->increase_threshold =3D (num_of_entries + 1) / 2;
+}
+
+struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct mlx5dr_icm_pool *pool=
,
+					      enum mlx5dr_icm_chunk_size chunk_size,
+					      u8 lu_type, u16 byte_mask)
+{
+	struct mlx5dr_icm_chunk *chunk;
+	struct mlx5dr_ste_htbl *htbl;
+	int i;
+
+	htbl =3D kzalloc(sizeof(*htbl), GFP_KERNEL);
+	if (!htbl)
+		return NULL;
+
+	chunk =3D mlx5dr_icm_alloc_chunk(pool, chunk_size);
+	if (!chunk)
+		goto out_free_htbl;
+
+	htbl->chunk =3D chunk;
+	htbl->lu_type =3D lu_type;
+	htbl->byte_mask =3D byte_mask;
+	htbl->ste_arr =3D chunk->ste_arr;
+	htbl->hw_ste_arr =3D chunk->hw_ste_arr;
+	htbl->miss_list =3D chunk->miss_list;
+	refcount_set(&htbl->refcount, 0);
+
+	for (i =3D 0; i < chunk->num_of_entries; i++) {
+		struct mlx5dr_ste *ste =3D &htbl->ste_arr[i];
+
+		ste->hw_ste =3D htbl->hw_ste_arr + i * DR_STE_SIZE_REDUCED;
+		ste->htbl =3D htbl;
+		refcount_set(&ste->refcount, 0);
+		INIT_LIST_HEAD(&ste->miss_list_node);
+		INIT_LIST_HEAD(&htbl->miss_list[i]);
+		INIT_LIST_HEAD(&ste->rule_list);
+	}
+
+	htbl->chunk_size =3D chunk_size;
+	dr_ste_set_ctrl(htbl);
+	return htbl;
+
+out_free_htbl:
+	kfree(htbl);
+	return NULL;
+}
+
+int mlx5dr_ste_htbl_free(struct mlx5dr_ste_htbl *htbl)
+{
+	if (refcount_read(&htbl->refcount))
+		return -EBUSY;
+
+	mlx5dr_icm_free_chunk(htbl->chunk);
+	kfree(htbl);
+	return 0;
+}
+
+int mlx5dr_ste_build_pre_check(struct mlx5dr_domain *dmn,
+			       u8 match_criteria,
+			       struct mlx5dr_match_param *mask,
+			       struct mlx5dr_match_param *value)
+{
+	if (!value && (match_criteria & DR_MATCHER_CRITERIA_MISC)) {
+		if (mask->misc.source_port && mask->misc.source_port !=3D 0xffff) {
+			mlx5dr_dbg(dmn, "Partial mask source_port is not supported\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *matcher,
+			     struct mlx5dr_matcher_rx_tx *nic_matcher,
+			     struct mlx5dr_match_param *value,
+			     u8 *ste_arr)
+{
+	struct mlx5dr_domain_rx_tx *nic_dmn =3D nic_matcher->nic_tbl->nic_dmn;
+	struct mlx5dr_domain *dmn =3D matcher->tbl->dmn;
+	struct mlx5dr_ste_build *sb;
+	int ret, i;
+
+	ret =3D mlx5dr_ste_build_pre_check(dmn, matcher->match_criteria,
+					 &matcher->mask, value);
+	if (ret)
+		return ret;
+
+	sb =3D nic_matcher->ste_builder;
+	for (i =3D 0; i < nic_matcher->num_of_builders; i++) {
+		mlx5dr_ste_init(ste_arr,
+				sb->lu_type,
+				nic_dmn->ste_type,
+				dmn->info.caps.gvmi);
+
+		mlx5dr_ste_set_bit_mask(ste_arr, sb->bit_mask);
+
+		ret =3D sb->ste_build_tag_func(value, sb, ste_arr);
+		if (ret)
+			return ret;
+
+		/* Connect the STEs */
+		if (i < (nic_matcher->num_of_builders - 1)) {
+			/* Need the next builder for these fields,
+			 * not relevant for the last ste in the chain.
+			 */
+			sb++;
+			MLX5_SET(ste_general, ste_arr, next_lu_type, sb->lu_type);
+			MLX5_SET(ste_general, ste_arr, byte_mask, sb->byte_mask);
+		}
+		ste_arr +=3D DR_STE_SIZE;
+	}
+	return 0;
+}
+
+static int dr_ste_build_eth_l2_src_des_bit_mask(struct mlx5dr_match_param =
*value,
+						bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask =3D inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, dmac_47_16, mask, dmac_47_16)=
;
+	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, dmac_15_0, mask, dmac_15_0);
+
+	if (mask->smac_47_16 || mask->smac_15_0) {
+		MLX5_SET(ste_eth_l2_src_dst, bit_mask, smac_47_32,
+			 mask->smac_47_16 >> 16);
+		MLX5_SET(ste_eth_l2_src_dst, bit_mask, smac_31_0,
+			 mask->smac_47_16 << 16 | mask->smac_15_0);
+		mask->smac_47_16 =3D 0;
+		mask->smac_15_0 =3D 0;
+	}
+
+	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, first_vlan_id, mask, first_vi=
d);
+	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, first_cfi, mask, first_cfi);
+	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, first_priority, mask, first_p=
rio);
+	DR_STE_SET_MASK(eth_l2_src_dst, bit_mask, l3_type, mask, ip_version);
+
+	if (mask->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_src_dst, bit_mask, first_vlan_qualifier, -1);
+		mask->cvlan_tag =3D 0;
+	} else if (mask->svlan_tag) {
+		MLX5_SET(ste_eth_l2_src_dst, bit_mask, first_vlan_qualifier, -1);
+		mask->svlan_tag =3D 0;
+	}
+
+	if (mask->cvlan_tag || mask->svlan_tag) {
+		pr_info("Invalid c/svlan mask configuration\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void dr_ste_copy_mask_misc(char *mask, struct mlx5dr_match_misc *sp=
ec)
+{
+	spec->gre_c_present =3D MLX5_GET(fte_match_set_misc, mask, gre_c_present)=
;
+	spec->gre_k_present =3D MLX5_GET(fte_match_set_misc, mask, gre_k_present)=
;
+	spec->gre_s_present =3D MLX5_GET(fte_match_set_misc, mask, gre_s_present)=
;
+	spec->source_vhca_port =3D MLX5_GET(fte_match_set_misc, mask, source_vhca=
_port);
+	spec->source_sqn =3D MLX5_GET(fte_match_set_misc, mask, source_sqn);
+
+	spec->source_port =3D MLX5_GET(fte_match_set_misc, mask, source_port);
+
+	spec->outer_second_prio =3D MLX5_GET(fte_match_set_misc, mask, outer_seco=
nd_prio);
+	spec->outer_second_cfi =3D MLX5_GET(fte_match_set_misc, mask, outer_secon=
d_cfi);
+	spec->outer_second_vid =3D MLX5_GET(fte_match_set_misc, mask, outer_secon=
d_vid);
+	spec->inner_second_prio =3D MLX5_GET(fte_match_set_misc, mask, inner_seco=
nd_prio);
+	spec->inner_second_cfi =3D MLX5_GET(fte_match_set_misc, mask, inner_secon=
d_cfi);
+	spec->inner_second_vid =3D MLX5_GET(fte_match_set_misc, mask, inner_secon=
d_vid);
+
+	spec->outer_second_cvlan_tag =3D
+		MLX5_GET(fte_match_set_misc, mask, outer_second_cvlan_tag);
+	spec->inner_second_cvlan_tag =3D
+		MLX5_GET(fte_match_set_misc, mask, inner_second_cvlan_tag);
+	spec->outer_second_svlan_tag =3D
+		MLX5_GET(fte_match_set_misc, mask, outer_second_svlan_tag);
+	spec->inner_second_svlan_tag =3D
+		MLX5_GET(fte_match_set_misc, mask, inner_second_svlan_tag);
+
+	spec->gre_protocol =3D MLX5_GET(fte_match_set_misc, mask, gre_protocol);
+
+	spec->gre_key_h =3D MLX5_GET(fte_match_set_misc, mask, gre_key.nvgre.hi);
+	spec->gre_key_l =3D MLX5_GET(fte_match_set_misc, mask, gre_key.nvgre.lo);
+
+	spec->vxlan_vni =3D MLX5_GET(fte_match_set_misc, mask, vxlan_vni);
+
+	spec->geneve_vni =3D MLX5_GET(fte_match_set_misc, mask, geneve_vni);
+	spec->geneve_oam =3D MLX5_GET(fte_match_set_misc, mask, geneve_oam);
+
+	spec->outer_ipv6_flow_label =3D
+		MLX5_GET(fte_match_set_misc, mask, outer_ipv6_flow_label);
+
+	spec->inner_ipv6_flow_label =3D
+		MLX5_GET(fte_match_set_misc, mask, inner_ipv6_flow_label);
+
+	spec->geneve_opt_len =3D MLX5_GET(fte_match_set_misc, mask, geneve_opt_le=
n);
+	spec->geneve_protocol_type =3D
+		MLX5_GET(fte_match_set_misc, mask, geneve_protocol_type);
+
+	spec->bth_dst_qp =3D MLX5_GET(fte_match_set_misc, mask, bth_dst_qp);
+}
+
+static void dr_ste_copy_mask_spec(char *mask, struct mlx5dr_match_spec *sp=
ec)
+{
+	u32 raw_ip[4];
+
+	spec->smac_47_16 =3D MLX5_GET(fte_match_set_lyr_2_4, mask, smac_47_16);
+
+	spec->smac_15_0 =3D MLX5_GET(fte_match_set_lyr_2_4, mask, smac_15_0);
+	spec->ethertype =3D MLX5_GET(fte_match_set_lyr_2_4, mask, ethertype);
+
+	spec->dmac_47_16 =3D MLX5_GET(fte_match_set_lyr_2_4, mask, dmac_47_16);
+
+	spec->dmac_15_0 =3D MLX5_GET(fte_match_set_lyr_2_4, mask, dmac_15_0);
+	spec->first_prio =3D MLX5_GET(fte_match_set_lyr_2_4, mask, first_prio);
+	spec->first_cfi =3D MLX5_GET(fte_match_set_lyr_2_4, mask, first_cfi);
+	spec->first_vid =3D MLX5_GET(fte_match_set_lyr_2_4, mask, first_vid);
+
+	spec->ip_protocol =3D MLX5_GET(fte_match_set_lyr_2_4, mask, ip_protocol);
+	spec->ip_dscp =3D MLX5_GET(fte_match_set_lyr_2_4, mask, ip_dscp);
+	spec->ip_ecn =3D MLX5_GET(fte_match_set_lyr_2_4, mask, ip_ecn);
+	spec->cvlan_tag =3D MLX5_GET(fte_match_set_lyr_2_4, mask, cvlan_tag);
+	spec->svlan_tag =3D MLX5_GET(fte_match_set_lyr_2_4, mask, svlan_tag);
+	spec->frag =3D MLX5_GET(fte_match_set_lyr_2_4, mask, frag);
+	spec->ip_version =3D MLX5_GET(fte_match_set_lyr_2_4, mask, ip_version);
+	spec->tcp_flags =3D MLX5_GET(fte_match_set_lyr_2_4, mask, tcp_flags);
+	spec->tcp_sport =3D MLX5_GET(fte_match_set_lyr_2_4, mask, tcp_sport);
+	spec->tcp_dport =3D MLX5_GET(fte_match_set_lyr_2_4, mask, tcp_dport);
+
+	spec->ttl_hoplimit =3D MLX5_GET(fte_match_set_lyr_2_4, mask, ttl_hoplimit=
);
+
+	spec->udp_sport =3D MLX5_GET(fte_match_set_lyr_2_4, mask, udp_sport);
+	spec->udp_dport =3D MLX5_GET(fte_match_set_lyr_2_4, mask, udp_dport);
+
+	memcpy(raw_ip, MLX5_ADDR_OF(fte_match_set_lyr_2_4, mask,
+				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+				    sizeof(raw_ip));
+
+	spec->src_ip_127_96 =3D be32_to_cpu(raw_ip[0]);
+	spec->src_ip_95_64 =3D be32_to_cpu(raw_ip[1]);
+	spec->src_ip_63_32 =3D be32_to_cpu(raw_ip[2]);
+	spec->src_ip_31_0 =3D be32_to_cpu(raw_ip[3]);
+
+	memcpy(raw_ip, MLX5_ADDR_OF(fte_match_set_lyr_2_4, mask,
+				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+				    sizeof(raw_ip));
+
+	spec->dst_ip_127_96 =3D be32_to_cpu(raw_ip[0]);
+	spec->dst_ip_95_64 =3D be32_to_cpu(raw_ip[1]);
+	spec->dst_ip_63_32 =3D be32_to_cpu(raw_ip[2]);
+	spec->dst_ip_31_0 =3D be32_to_cpu(raw_ip[3]);
+}
+
+static void dr_ste_copy_mask_misc2(char *mask, struct mlx5dr_match_misc2 *=
spec)
+{
+	spec->outer_first_mpls_label =3D
+		MLX5_GET(fte_match_set_misc2, mask, outer_first_mpls.mpls_label);
+	spec->outer_first_mpls_exp =3D
+		MLX5_GET(fte_match_set_misc2, mask, outer_first_mpls.mpls_exp);
+	spec->outer_first_mpls_s_bos =3D
+		MLX5_GET(fte_match_set_misc2, mask, outer_first_mpls.mpls_s_bos);
+	spec->outer_first_mpls_ttl =3D
+		MLX5_GET(fte_match_set_misc2, mask, outer_first_mpls.mpls_ttl);
+	spec->inner_first_mpls_label =3D
+		MLX5_GET(fte_match_set_misc2, mask, inner_first_mpls.mpls_label);
+	spec->inner_first_mpls_exp =3D
+		MLX5_GET(fte_match_set_misc2, mask, inner_first_mpls.mpls_exp);
+	spec->inner_first_mpls_s_bos =3D
+		MLX5_GET(fte_match_set_misc2, mask, inner_first_mpls.mpls_s_bos);
+	spec->inner_first_mpls_ttl =3D
+		MLX5_GET(fte_match_set_misc2, mask, inner_first_mpls.mpls_ttl);
+	spec->outer_first_mpls_over_gre_label =3D
+		MLX5_GET(fte_match_set_misc2, mask, outer_first_mpls_over_gre.mpls_label=
);
+	spec->outer_first_mpls_over_gre_exp =3D
+		MLX5_GET(fte_match_set_misc2, mask, outer_first_mpls_over_gre.mpls_exp);
+	spec->outer_first_mpls_over_gre_s_bos =3D
+		MLX5_GET(fte_match_set_misc2, mask, outer_first_mpls_over_gre.mpls_s_bos=
);
+	spec->outer_first_mpls_over_gre_ttl =3D
+		MLX5_GET(fte_match_set_misc2, mask, outer_first_mpls_over_gre.mpls_ttl);
+	spec->outer_first_mpls_over_udp_label =3D
+		MLX5_GET(fte_match_set_misc2, mask, outer_first_mpls_over_udp.mpls_label=
);
+	spec->outer_first_mpls_over_udp_exp =3D
+		MLX5_GET(fte_match_set_misc2, mask, outer_first_mpls_over_udp.mpls_exp);
+	spec->outer_first_mpls_over_udp_s_bos =3D
+		MLX5_GET(fte_match_set_misc2, mask, outer_first_mpls_over_udp.mpls_s_bos=
);
+	spec->outer_first_mpls_over_udp_ttl =3D
+		MLX5_GET(fte_match_set_misc2, mask, outer_first_mpls_over_udp.mpls_ttl);
+	spec->metadata_reg_c_7 =3D MLX5_GET(fte_match_set_misc2, mask, metadata_r=
eg_c_7);
+	spec->metadata_reg_c_6 =3D MLX5_GET(fte_match_set_misc2, mask, metadata_r=
eg_c_6);
+	spec->metadata_reg_c_5 =3D MLX5_GET(fte_match_set_misc2, mask, metadata_r=
eg_c_5);
+	spec->metadata_reg_c_4 =3D MLX5_GET(fte_match_set_misc2, mask, metadata_r=
eg_c_4);
+	spec->metadata_reg_c_3 =3D MLX5_GET(fte_match_set_misc2, mask, metadata_r=
eg_c_3);
+	spec->metadata_reg_c_2 =3D MLX5_GET(fte_match_set_misc2, mask, metadata_r=
eg_c_2);
+	spec->metadata_reg_c_1 =3D MLX5_GET(fte_match_set_misc2, mask, metadata_r=
eg_c_1);
+	spec->metadata_reg_c_0 =3D MLX5_GET(fte_match_set_misc2, mask, metadata_r=
eg_c_0);
+	spec->metadata_reg_a =3D MLX5_GET(fte_match_set_misc2, mask, metadata_reg=
_a);
+	spec->metadata_reg_b =3D MLX5_GET(fte_match_set_misc2, mask, metadata_reg=
_b);
+}
+
+static void dr_ste_copy_mask_misc3(char *mask, struct mlx5dr_match_misc3 *=
spec)
+{
+	spec->inner_tcp_seq_num =3D MLX5_GET(fte_match_set_misc3, mask, inner_tcp=
_seq_num);
+	spec->outer_tcp_seq_num =3D MLX5_GET(fte_match_set_misc3, mask, outer_tcp=
_seq_num);
+	spec->inner_tcp_ack_num =3D MLX5_GET(fte_match_set_misc3, mask, inner_tcp=
_ack_num);
+	spec->outer_tcp_ack_num =3D MLX5_GET(fte_match_set_misc3, mask, outer_tcp=
_ack_num);
+	spec->outer_vxlan_gpe_vni =3D
+		MLX5_GET(fte_match_set_misc3, mask, outer_vxlan_gpe_vni);
+	spec->outer_vxlan_gpe_next_protocol =3D
+		MLX5_GET(fte_match_set_misc3, mask, outer_vxlan_gpe_next_protocol);
+	spec->outer_vxlan_gpe_flags =3D
+		MLX5_GET(fte_match_set_misc3, mask, outer_vxlan_gpe_flags);
+	spec->icmpv4_header_data =3D MLX5_GET(fte_match_set_misc3, mask, icmp_hea=
der_data);
+	spec->icmpv6_header_data =3D
+		MLX5_GET(fte_match_set_misc3, mask, icmpv6_header_data);
+	spec->icmpv4_type =3D MLX5_GET(fte_match_set_misc3, mask, icmp_type);
+	spec->icmpv4_code =3D MLX5_GET(fte_match_set_misc3, mask, icmp_code);
+	spec->icmpv6_type =3D MLX5_GET(fte_match_set_misc3, mask, icmpv6_type);
+	spec->icmpv6_code =3D MLX5_GET(fte_match_set_misc3, mask, icmpv6_code);
+}
+
+void mlx5dr_ste_copy_param(u8 match_criteria,
+			   struct mlx5dr_match_param *set_param,
+			   struct mlx5dr_match_parameters *mask)
+{
+	u8 tail_param[MLX5_ST_SZ_BYTES(fte_match_set_lyr_2_4)] =3D {};
+	u8 *data =3D (u8 *)mask->match_buf;
+	size_t param_location;
+	void *buff;
+
+	if (match_criteria & DR_MATCHER_CRITERIA_OUTER) {
+		if (mask->match_sz < sizeof(struct mlx5dr_match_spec)) {
+			memcpy(tail_param, data, mask->match_sz);
+			buff =3D tail_param;
+		} else {
+			buff =3D mask->match_buf;
+		}
+		dr_ste_copy_mask_spec(buff, &set_param->outer);
+	}
+	param_location =3D sizeof(struct mlx5dr_match_spec);
+
+	if (match_criteria & DR_MATCHER_CRITERIA_MISC) {
+		if (mask->match_sz < param_location +
+		    sizeof(struct mlx5dr_match_misc)) {
+			memcpy(tail_param, data + param_location,
+			       mask->match_sz - param_location);
+			buff =3D tail_param;
+		} else {
+			buff =3D data + param_location;
+		}
+		dr_ste_copy_mask_misc(buff, &set_param->misc);
+	}
+	param_location +=3D sizeof(struct mlx5dr_match_misc);
+
+	if (match_criteria & DR_MATCHER_CRITERIA_INNER) {
+		if (mask->match_sz < param_location +
+		    sizeof(struct mlx5dr_match_spec)) {
+			memcpy(tail_param, data + param_location,
+			       mask->match_sz - param_location);
+			buff =3D tail_param;
+		} else {
+			buff =3D data + param_location;
+		}
+		dr_ste_copy_mask_spec(buff, &set_param->inner);
+	}
+	param_location +=3D sizeof(struct mlx5dr_match_spec);
+
+	if (match_criteria & DR_MATCHER_CRITERIA_MISC2) {
+		if (mask->match_sz < param_location +
+		    sizeof(struct mlx5dr_match_misc2)) {
+			memcpy(tail_param, data + param_location,
+			       mask->match_sz - param_location);
+			buff =3D tail_param;
+		} else {
+			buff =3D data + param_location;
+		}
+		dr_ste_copy_mask_misc2(buff, &set_param->misc2);
+	}
+
+	param_location +=3D sizeof(struct mlx5dr_match_misc2);
+
+	if (match_criteria & DR_MATCHER_CRITERIA_MISC3) {
+		if (mask->match_sz < param_location +
+		    sizeof(struct mlx5dr_match_misc3)) {
+			memcpy(tail_param, data + param_location,
+			       mask->match_sz - param_location);
+			buff =3D tail_param;
+		} else {
+			buff =3D data + param_location;
+		}
+		dr_ste_copy_mask_misc3(buff, &set_param->misc3);
+	}
+}
+
+static int dr_ste_build_eth_l2_src_des_tag(struct mlx5dr_match_param *valu=
e,
+					   struct mlx5dr_ste_build *sb,
+					   u8 *hw_ste_p)
+{
+	struct mlx5dr_match_spec *spec =3D sb->inner ? &value->inner : &value->ou=
ter;
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(eth_l2_src_dst, tag, dmac_47_16, spec, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_src_dst, tag, dmac_15_0, spec, dmac_15_0);
+
+	if (spec->smac_47_16 || spec->smac_15_0) {
+		MLX5_SET(ste_eth_l2_src_dst, tag, smac_47_32,
+			 spec->smac_47_16 >> 16);
+		MLX5_SET(ste_eth_l2_src_dst, tag, smac_31_0,
+			 spec->smac_47_16 << 16 | spec->smac_15_0);
+		spec->smac_47_16 =3D 0;
+		spec->smac_15_0 =3D 0;
+	}
+
+	if (spec->ip_version) {
+		if (spec->ip_version =3D=3D IP_VERSION_IPV4) {
+			MLX5_SET(ste_eth_l2_src_dst, tag, l3_type, STE_IPV4);
+			spec->ip_version =3D 0;
+		} else if (spec->ip_version =3D=3D IP_VERSION_IPV6) {
+			MLX5_SET(ste_eth_l2_src_dst, tag, l3_type, STE_IPV6);
+			spec->ip_version =3D 0;
+		} else {
+			pr_info("Unsupported ip_version value\n");
+			return -EINVAL;
+		}
+	}
+
+	DR_STE_SET_TAG(eth_l2_src_dst, tag, first_vlan_id, spec, first_vid);
+	DR_STE_SET_TAG(eth_l2_src_dst, tag, first_cfi, spec, first_cfi);
+	DR_STE_SET_TAG(eth_l2_src_dst, tag, first_priority, spec, first_prio);
+
+	if (spec->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_src_dst, tag, first_vlan_qualifier, DR_STE_CVLAN);
+		spec->cvlan_tag =3D 0;
+	} else if (spec->svlan_tag) {
+		MLX5_SET(ste_eth_l2_src_dst, tag, first_vlan_qualifier, DR_STE_SVLAN);
+		spec->svlan_tag =3D 0;
+	}
+	return 0;
+}
+
+int mlx5dr_ste_build_eth_l2_src_des(struct mlx5dr_ste_build *sb,
+				    struct mlx5dr_match_param *mask,
+				    bool inner, bool rx)
+{
+	int ret;
+
+	ret =3D dr_ste_build_eth_l2_src_des_bit_mask(mask, inner, sb->bit_mask);
+	if (ret)
+		return ret;
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D DR_STE_CALC_LU_TYPE(ETHL2_SRC_DST, rx, inner);
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_eth_l2_src_des_tag;
+
+	return 0;
+}
+
+static void dr_ste_build_eth_l3_ipv6_dst_bit_mask(struct mlx5dr_match_para=
m *value,
+						  bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask =3D inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l3_ipv6_dst, bit_mask, dst_ip_127_96, mask, dst_ip_=
127_96);
+	DR_STE_SET_MASK_V(eth_l3_ipv6_dst, bit_mask, dst_ip_95_64, mask, dst_ip_9=
5_64);
+	DR_STE_SET_MASK_V(eth_l3_ipv6_dst, bit_mask, dst_ip_63_32, mask, dst_ip_6=
3_32);
+	DR_STE_SET_MASK_V(eth_l3_ipv6_dst, bit_mask, dst_ip_31_0, mask, dst_ip_31=
_0);
+}
+
+static int dr_ste_build_eth_l3_ipv6_dst_tag(struct mlx5dr_match_param *val=
ue,
+					    struct mlx5dr_ste_build *sb,
+					    u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_spec *spec =3D sb->inner ? &value->inner : &value->ou=
ter;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_127_96, spec, dst_ip_127_96);
+	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_95_64, spec, dst_ip_95_64);
+	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_63_32, spec, dst_ip_63_32);
+	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_31_0, spec, dst_ip_31_0);
+
+	return 0;
+}
+
+void mlx5dr_ste_build_eth_l3_ipv6_dst(struct mlx5dr_ste_build *sb,
+				      struct mlx5dr_match_param *mask,
+				      bool inner, bool rx)
+{
+	dr_ste_build_eth_l3_ipv6_dst_bit_mask(mask, inner, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D DR_STE_CALC_LU_TYPE(ETHL3_IPV6_DST, rx, inner);
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_eth_l3_ipv6_dst_tag;
+}
+
+static void dr_ste_build_eth_l3_ipv6_src_bit_mask(struct mlx5dr_match_para=
m *value,
+						  bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask =3D inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l3_ipv6_src, bit_mask, src_ip_127_96, mask, src_ip_=
127_96);
+	DR_STE_SET_MASK_V(eth_l3_ipv6_src, bit_mask, src_ip_95_64, mask, src_ip_9=
5_64);
+	DR_STE_SET_MASK_V(eth_l3_ipv6_src, bit_mask, src_ip_63_32, mask, src_ip_6=
3_32);
+	DR_STE_SET_MASK_V(eth_l3_ipv6_src, bit_mask, src_ip_31_0, mask, src_ip_31=
_0);
+}
+
+static int dr_ste_build_eth_l3_ipv6_src_tag(struct mlx5dr_match_param *val=
ue,
+					    struct mlx5dr_ste_build *sb,
+					    u8 *hw_ste_p)
+{
+	struct mlx5dr_match_spec *spec =3D sb->inner ? &value->inner : &value->ou=
ter;
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_127_96, spec, src_ip_127_96);
+	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_95_64, spec, src_ip_95_64);
+	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_63_32, spec, src_ip_63_32);
+	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_31_0, spec, src_ip_31_0);
+
+	return 0;
+}
+
+void mlx5dr_ste_build_eth_l3_ipv6_src(struct mlx5dr_ste_build *sb,
+				      struct mlx5dr_match_param *mask,
+				      bool inner, bool rx)
+{
+	dr_ste_build_eth_l3_ipv6_src_bit_mask(mask, inner, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D DR_STE_CALC_LU_TYPE(ETHL3_IPV6_SRC, rx, inner);
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_eth_l3_ipv6_src_tag;
+}
+
+static void dr_ste_build_eth_l3_ipv4_5_tuple_bit_mask(struct mlx5dr_match_=
param *value,
+						      bool inner,
+						      u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask =3D inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  destination_address, mask, dst_ip_31_0);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  source_address, mask, src_ip_31_0);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  destination_port, mask, tcp_dport);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  destination_port, mask, udp_dport);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  source_port, mask, tcp_sport);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  source_port, mask, udp_sport);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  protocol, mask, ip_protocol);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  fragmented, mask, frag);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  dscp, mask, ip_dscp);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  ecn, mask, ip_ecn);
+
+	if (mask->tcp_flags) {
+		DR_STE_SET_TCP_FLAGS(eth_l3_ipv4_5_tuple, bit_mask, mask);
+		mask->tcp_flags =3D 0;
+	}
+}
+
+static int dr_ste_build_eth_l3_ipv4_5_tuple_tag(struct mlx5dr_match_param =
*value,
+						struct mlx5dr_ste_build *sb,
+						u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_spec *spec =3D sb->inner ? &value->inner : &value->ou=
ter;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, destination_address, spec, dst_i=
p_31_0);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, source_address, spec, src_ip_31_=
0);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, destination_port, spec, tcp_dpor=
t);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, destination_port, spec, udp_dpor=
t);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, source_port, spec, tcp_sport);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, source_port, spec, udp_sport);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, protocol, spec, ip_protocol);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, fragmented, spec, frag);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, dscp, spec, ip_dscp);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, ecn, spec, ip_ecn);
+
+	if (spec->tcp_flags) {
+		DR_STE_SET_TCP_FLAGS(eth_l3_ipv4_5_tuple, tag, spec);
+		spec->tcp_flags =3D 0;
+	}
+
+	return 0;
+}
+
+void mlx5dr_ste_build_eth_l3_ipv4_5_tuple(struct mlx5dr_ste_build *sb,
+					  struct mlx5dr_match_param *mask,
+					  bool inner, bool rx)
+{
+	dr_ste_build_eth_l3_ipv4_5_tuple_bit_mask(mask, inner, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D DR_STE_CALC_LU_TYPE(ETHL3_IPV4_5_TUPLE, rx, inner);
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_eth_l3_ipv4_5_tuple_tag;
+}
+
+static void
+dr_ste_build_eth_l2_src_or_dst_bit_mask(struct mlx5dr_match_param *value,
+					bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask =3D inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_misc *misc_mask =3D &value->misc;
+
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, first_vlan_id, mask, first_vid);
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, first_cfi, mask, first_cfi);
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, first_priority, mask, first_prio)=
;
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, ip_fragmented, mask, frag);
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, l3_ethertype, mask, ethertype);
+	DR_STE_SET_MASK(eth_l2_src, bit_mask, l3_type, mask, ip_version);
+
+	if (mask->svlan_tag || mask->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_src, bit_mask, first_vlan_qualifier, -1);
+		mask->cvlan_tag =3D 0;
+		mask->svlan_tag =3D 0;
+	}
+
+	if (inner) {
+		if (misc_mask->inner_second_cvlan_tag ||
+		    misc_mask->inner_second_svlan_tag) {
+			MLX5_SET(ste_eth_l2_src, bit_mask, second_vlan_qualifier, -1);
+			misc_mask->inner_second_cvlan_tag =3D 0;
+			misc_mask->inner_second_svlan_tag =3D 0;
+		}
+
+		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
+				  second_vlan_id, misc_mask, inner_second_vid);
+		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
+				  second_cfi, misc_mask, inner_second_cfi);
+		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
+				  second_priority, misc_mask, inner_second_prio);
+	} else {
+		if (misc_mask->outer_second_cvlan_tag ||
+		    misc_mask->outer_second_svlan_tag) {
+			MLX5_SET(ste_eth_l2_src, bit_mask, second_vlan_qualifier, -1);
+			misc_mask->outer_second_cvlan_tag =3D 0;
+			misc_mask->outer_second_svlan_tag =3D 0;
+		}
+
+		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
+				  second_vlan_id, misc_mask, outer_second_vid);
+		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
+				  second_cfi, misc_mask, outer_second_cfi);
+		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
+				  second_priority, misc_mask, outer_second_prio);
+	}
+}
+
+static int dr_ste_build_eth_l2_src_or_dst_tag(struct mlx5dr_match_param *v=
alue,
+					      bool inner, u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_spec *spec =3D inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_misc *misc_spec =3D &value->misc;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(eth_l2_src, tag, first_vlan_id, spec, first_vid);
+	DR_STE_SET_TAG(eth_l2_src, tag, first_cfi, spec, first_cfi);
+	DR_STE_SET_TAG(eth_l2_src, tag, first_priority, spec, first_prio);
+	DR_STE_SET_TAG(eth_l2_src, tag, ip_fragmented, spec, frag);
+	DR_STE_SET_TAG(eth_l2_src, tag, l3_ethertype, spec, ethertype);
+
+	if (spec->ip_version) {
+		if (spec->ip_version =3D=3D IP_VERSION_IPV4) {
+			MLX5_SET(ste_eth_l2_src, tag, l3_type, STE_IPV4);
+			spec->ip_version =3D 0;
+		} else if (spec->ip_version =3D=3D IP_VERSION_IPV6) {
+			MLX5_SET(ste_eth_l2_src, tag, l3_type, STE_IPV6);
+			spec->ip_version =3D 0;
+		} else {
+			pr_info("Unsupported ip_version value\n");
+			return -EINVAL;
+		}
+	}
+
+	if (spec->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_src, tag, first_vlan_qualifier, DR_STE_CVLAN);
+		spec->cvlan_tag =3D 0;
+	} else if (spec->svlan_tag) {
+		MLX5_SET(ste_eth_l2_src, tag, first_vlan_qualifier, DR_STE_SVLAN);
+		spec->svlan_tag =3D 0;
+	}
+
+	if (inner) {
+		if (misc_spec->inner_second_cvlan_tag) {
+			MLX5_SET(ste_eth_l2_src, tag, second_vlan_qualifier, DR_STE_CVLAN);
+			misc_spec->inner_second_cvlan_tag =3D 0;
+		} else if (misc_spec->inner_second_svlan_tag) {
+			MLX5_SET(ste_eth_l2_src, tag, second_vlan_qualifier, DR_STE_SVLAN);
+			misc_spec->inner_second_svlan_tag =3D 0;
+		}
+
+		DR_STE_SET_TAG(eth_l2_src, tag, second_vlan_id, misc_spec, inner_second_=
vid);
+		DR_STE_SET_TAG(eth_l2_src, tag, second_cfi, misc_spec, inner_second_cfi)=
;
+		DR_STE_SET_TAG(eth_l2_src, tag, second_priority, misc_spec, inner_second=
_prio);
+	} else {
+		if (misc_spec->outer_second_cvlan_tag) {
+			MLX5_SET(ste_eth_l2_src, tag, second_vlan_qualifier, DR_STE_CVLAN);
+			misc_spec->outer_second_cvlan_tag =3D 0;
+		} else if (misc_spec->outer_second_svlan_tag) {
+			MLX5_SET(ste_eth_l2_src, tag, second_vlan_qualifier, DR_STE_SVLAN);
+			misc_spec->outer_second_svlan_tag =3D 0;
+		}
+		DR_STE_SET_TAG(eth_l2_src, tag, second_vlan_id, misc_spec, outer_second_=
vid);
+		DR_STE_SET_TAG(eth_l2_src, tag, second_cfi, misc_spec, outer_second_cfi)=
;
+		DR_STE_SET_TAG(eth_l2_src, tag, second_priority, misc_spec, outer_second=
_prio);
+	}
+
+	return 0;
+}
+
+static void dr_ste_build_eth_l2_src_bit_mask(struct mlx5dr_match_param *va=
lue,
+					     bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask =3D inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, smac_47_16, mask, smac_47_16);
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, smac_15_0, mask, smac_15_0);
+
+	dr_ste_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
+}
+
+static int dr_ste_build_eth_l2_src_tag(struct mlx5dr_match_param *value,
+				       struct mlx5dr_ste_build *sb,
+				       u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_spec *spec =3D sb->inner ? &value->inner : &value->ou=
ter;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(eth_l2_src, tag, smac_47_16, spec, smac_47_16);
+	DR_STE_SET_TAG(eth_l2_src, tag, smac_15_0, spec, smac_15_0);
+
+	return dr_ste_build_eth_l2_src_or_dst_tag(value, sb->inner, hw_ste_p);
+}
+
+void mlx5dr_ste_build_eth_l2_src(struct mlx5dr_ste_build *sb,
+				 struct mlx5dr_match_param *mask,
+				 bool inner, bool rx)
+{
+	dr_ste_build_eth_l2_src_bit_mask(mask, inner, sb->bit_mask);
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D DR_STE_CALC_LU_TYPE(ETHL2_SRC, rx, inner);
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_eth_l2_src_tag;
+}
+
+static void dr_ste_build_eth_l2_dst_bit_mask(struct mlx5dr_match_param *va=
lue,
+					     bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask =3D inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l2_dst, bit_mask, dmac_47_16, mask, dmac_47_16);
+	DR_STE_SET_MASK_V(eth_l2_dst, bit_mask, dmac_15_0, mask, dmac_15_0);
+
+	dr_ste_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
+}
+
+static int dr_ste_build_eth_l2_dst_tag(struct mlx5dr_match_param *value,
+				       struct mlx5dr_ste_build *sb,
+				       u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_spec *spec =3D sb->inner ? &value->inner : &value->ou=
ter;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(eth_l2_dst, tag, dmac_47_16, spec, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_dst, tag, dmac_15_0, spec, dmac_15_0);
+
+	return dr_ste_build_eth_l2_src_or_dst_tag(value, sb->inner, hw_ste_p);
+}
+
+void mlx5dr_ste_build_eth_l2_dst(struct mlx5dr_ste_build *sb,
+				 struct mlx5dr_match_param *mask,
+				 bool inner, bool rx)
+{
+	dr_ste_build_eth_l2_dst_bit_mask(mask, inner, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D DR_STE_CALC_LU_TYPE(ETHL2_DST, rx, inner);
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_eth_l2_dst_tag;
+}
+
+static void dr_ste_build_eth_l2_tnl_bit_mask(struct mlx5dr_match_param *va=
lue,
+					     bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask =3D inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_misc *misc =3D &value->misc;
+
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, dmac_47_16, mask, dmac_47_16);
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, dmac_15_0, mask, dmac_15_0);
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, first_vlan_id, mask, first_vid);
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, first_cfi, mask, first_cfi);
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, first_priority, mask, first_prio)=
;
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, ip_fragmented, mask, frag);
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, l3_ethertype, mask, ethertype);
+	DR_STE_SET_MASK(eth_l2_tnl, bit_mask, l3_type, mask, ip_version);
+
+	if (misc->vxlan_vni) {
+		MLX5_SET(ste_eth_l2_tnl, bit_mask,
+			 l2_tunneling_network_id, (misc->vxlan_vni << 8));
+		misc->vxlan_vni =3D 0;
+	}
+
+	if (mask->svlan_tag || mask->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_tnl, bit_mask, first_vlan_qualifier, -1);
+		mask->cvlan_tag =3D 0;
+		mask->svlan_tag =3D 0;
+	}
+}
+
+static int dr_ste_build_eth_l2_tnl_tag(struct mlx5dr_match_param *value,
+				       struct mlx5dr_ste_build *sb,
+				       u8 *hw_ste_p)
+{
+	struct mlx5dr_match_spec *spec =3D sb->inner ? &value->inner : &value->ou=
ter;
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_misc *misc =3D &value->misc;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(eth_l2_tnl, tag, dmac_47_16, spec, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_tnl, tag, dmac_15_0, spec, dmac_15_0);
+	DR_STE_SET_TAG(eth_l2_tnl, tag, first_vlan_id, spec, first_vid);
+	DR_STE_SET_TAG(eth_l2_tnl, tag, first_cfi, spec, first_cfi);
+	DR_STE_SET_TAG(eth_l2_tnl, tag, ip_fragmented, spec, frag);
+	DR_STE_SET_TAG(eth_l2_tnl, tag, first_priority, spec, first_prio);
+	DR_STE_SET_TAG(eth_l2_tnl, tag, l3_ethertype, spec, ethertype);
+
+	if (misc->vxlan_vni) {
+		MLX5_SET(ste_eth_l2_tnl, tag, l2_tunneling_network_id,
+			 (misc->vxlan_vni << 8));
+		misc->vxlan_vni =3D 0;
+	}
+
+	if (spec->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_tnl, tag, first_vlan_qualifier, DR_STE_CVLAN);
+		spec->cvlan_tag =3D 0;
+	} else if (spec->svlan_tag) {
+		MLX5_SET(ste_eth_l2_tnl, tag, first_vlan_qualifier, DR_STE_SVLAN);
+		spec->svlan_tag =3D 0;
+	}
+
+	if (spec->ip_version) {
+		if (spec->ip_version =3D=3D IP_VERSION_IPV4) {
+			MLX5_SET(ste_eth_l2_tnl, tag, l3_type, STE_IPV4);
+			spec->ip_version =3D 0;
+		} else if (spec->ip_version =3D=3D IP_VERSION_IPV6) {
+			MLX5_SET(ste_eth_l2_tnl, tag, l3_type, STE_IPV6);
+			spec->ip_version =3D 0;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+void mlx5dr_ste_build_eth_l2_tnl(struct mlx5dr_ste_build *sb,
+				 struct mlx5dr_match_param *mask, bool inner, bool rx)
+{
+	dr_ste_build_eth_l2_tnl_bit_mask(mask, inner, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D MLX5DR_STE_LU_TYPE_ETHL2_TUNNELING_I;
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_eth_l2_tnl_tag;
+}
+
+static void dr_ste_build_eth_l3_ipv4_misc_bit_mask(struct mlx5dr_match_par=
am *value,
+						   bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask =3D inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l3_ipv4_misc, bit_mask, time_to_live, mask, ttl_hop=
limit);
+}
+
+static int dr_ste_build_eth_l3_ipv4_misc_tag(struct mlx5dr_match_param *va=
lue,
+					     struct mlx5dr_ste_build *sb,
+					     u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_spec *spec =3D sb->inner ? &value->inner : &value->ou=
ter;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(eth_l3_ipv4_misc, tag, time_to_live, spec, ttl_hoplimit);
+
+	return 0;
+}
+
+void mlx5dr_ste_build_eth_l3_ipv4_misc(struct mlx5dr_ste_build *sb,
+				       struct mlx5dr_match_param *mask,
+				       bool inner, bool rx)
+{
+	dr_ste_build_eth_l3_ipv4_misc_bit_mask(mask, inner, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D DR_STE_CALC_LU_TYPE(ETHL3_IPV4_MISC, rx, inner);
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_eth_l3_ipv4_misc_tag;
+}
+
+static void dr_ste_build_ipv6_l3_l4_bit_mask(struct mlx5dr_match_param *va=
lue,
+					     bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask =3D inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, dst_port, mask, tcp_dport);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, src_port, mask, tcp_sport);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, dst_port, mask, udp_dport);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, src_port, mask, udp_sport);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, protocol, mask, ip_protocol);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, fragmented, mask, frag);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, dscp, mask, ip_dscp);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, ecn, mask, ip_ecn);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, ipv6_hop_limit, mask, ttl_hoplimit);
+
+	if (mask->tcp_flags) {
+		DR_STE_SET_TCP_FLAGS(eth_l4, bit_mask, mask);
+		mask->tcp_flags =3D 0;
+	}
+}
+
+static int dr_ste_build_ipv6_l3_l4_tag(struct mlx5dr_match_param *value,
+				       struct mlx5dr_ste_build *sb,
+				       u8 *hw_ste_p)
+{
+	struct mlx5dr_match_spec *spec =3D sb->inner ? &value->inner : &value->ou=
ter;
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(eth_l4, tag, dst_port, spec, tcp_dport);
+	DR_STE_SET_TAG(eth_l4, tag, src_port, spec, tcp_sport);
+	DR_STE_SET_TAG(eth_l4, tag, dst_port, spec, udp_dport);
+	DR_STE_SET_TAG(eth_l4, tag, src_port, spec, udp_sport);
+	DR_STE_SET_TAG(eth_l4, tag, protocol, spec, ip_protocol);
+	DR_STE_SET_TAG(eth_l4, tag, fragmented, spec, frag);
+	DR_STE_SET_TAG(eth_l4, tag, dscp, spec, ip_dscp);
+	DR_STE_SET_TAG(eth_l4, tag, ecn, spec, ip_ecn);
+	DR_STE_SET_TAG(eth_l4, tag, ipv6_hop_limit, spec, ttl_hoplimit);
+
+	if (spec->tcp_flags) {
+		DR_STE_SET_TCP_FLAGS(eth_l4, tag, spec);
+		spec->tcp_flags =3D 0;
+	}
+
+	return 0;
+}
+
+void mlx5dr_ste_build_ipv6_l3_l4(struct mlx5dr_ste_build *sb,
+				 struct mlx5dr_match_param *mask,
+				 bool inner, bool rx)
+{
+	dr_ste_build_ipv6_l3_l4_bit_mask(mask, inner, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D DR_STE_CALC_LU_TYPE(ETHL4, rx, inner);
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_ipv6_l3_l4_tag;
+}
+
+static int dr_ste_build_empty_always_hit_tag(struct mlx5dr_match_param *va=
lue,
+					     struct mlx5dr_ste_build *sb,
+					     u8 *hw_ste_p)
+{
+	return 0;
+}
+
+void mlx5dr_ste_build_empty_always_hit(struct mlx5dr_ste_build *sb, bool r=
x)
+{
+	sb->rx =3D rx;
+	sb->lu_type =3D MLX5DR_STE_LU_TYPE_DONT_CARE;
+	sb->byte_mask =3D 0;
+	sb->ste_build_tag_func =3D &dr_ste_build_empty_always_hit_tag;
+}
+
+static void dr_ste_build_mpls_bit_mask(struct mlx5dr_match_param *value,
+				       bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_misc2 *misc2_mask =3D &value->misc2;
+
+	if (inner)
+		DR_STE_SET_MPLS_MASK(mpls, misc2_mask, inner, bit_mask);
+	else
+		DR_STE_SET_MPLS_MASK(mpls, misc2_mask, outer, bit_mask);
+}
+
+static int dr_ste_build_mpls_tag(struct mlx5dr_match_param *value,
+				 struct mlx5dr_ste_build *sb,
+				 u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_misc2 *misc2_mask =3D &value->misc2;
+	u8 *tag =3D hw_ste->tag;
+
+	if (sb->inner)
+		DR_STE_SET_MPLS_TAG(mpls, misc2_mask, inner, tag);
+	else
+		DR_STE_SET_MPLS_TAG(mpls, misc2_mask, outer, tag);
+
+	return 0;
+}
+
+void mlx5dr_ste_build_mpls(struct mlx5dr_ste_build *sb,
+			   struct mlx5dr_match_param *mask,
+			   bool inner, bool rx)
+{
+	dr_ste_build_mpls_bit_mask(mask, inner, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D DR_STE_CALC_LU_TYPE(MPLS_FIRST, rx, inner);
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_mpls_tag;
+}
+
+static void dr_ste_build_gre_bit_mask(struct mlx5dr_match_param *value,
+				      bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_misc *misc_mask =3D &value->misc;
+
+	DR_STE_SET_MASK_V(gre, bit_mask, gre_protocol, misc_mask, gre_protocol);
+	DR_STE_SET_MASK_V(gre, bit_mask, gre_k_present, misc_mask, gre_k_present)=
;
+	DR_STE_SET_MASK_V(gre, bit_mask, gre_key_h, misc_mask, gre_key_h);
+	DR_STE_SET_MASK_V(gre, bit_mask, gre_key_l, misc_mask, gre_key_l);
+
+	DR_STE_SET_MASK_V(gre, bit_mask, gre_c_present, misc_mask, gre_c_present)=
;
+	DR_STE_SET_MASK_V(gre, bit_mask, gre_s_present, misc_mask, gre_s_present)=
;
+}
+
+static int dr_ste_build_gre_tag(struct mlx5dr_match_param *value,
+				struct mlx5dr_ste_build *sb,
+				u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct  mlx5dr_match_misc *misc =3D &value->misc;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(gre, tag, gre_protocol, misc, gre_protocol);
+
+	DR_STE_SET_TAG(gre, tag, gre_k_present, misc, gre_k_present);
+	DR_STE_SET_TAG(gre, tag, gre_key_h, misc, gre_key_h);
+	DR_STE_SET_TAG(gre, tag, gre_key_l, misc, gre_key_l);
+
+	DR_STE_SET_TAG(gre, tag, gre_c_present, misc, gre_c_present);
+
+	DR_STE_SET_TAG(gre, tag, gre_s_present, misc, gre_s_present);
+
+	return 0;
+}
+
+void mlx5dr_ste_build_gre(struct mlx5dr_ste_build *sb,
+			  struct mlx5dr_match_param *mask, bool inner, bool rx)
+{
+	dr_ste_build_gre_bit_mask(mask, inner, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D MLX5DR_STE_LU_TYPE_GRE;
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_gre_tag;
+}
+
+static void dr_ste_build_flex_parser_0_bit_mask(struct mlx5dr_match_param =
*value,
+						bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_misc2 *misc_2_mask =3D &value->misc2;
+
+	if (DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(misc_2_mask)) {
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_label,
+				  misc_2_mask, outer_first_mpls_over_gre_label);
+
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_exp,
+				  misc_2_mask, outer_first_mpls_over_gre_exp);
+
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_s_bos,
+				  misc_2_mask, outer_first_mpls_over_gre_s_bos);
+
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_ttl,
+				  misc_2_mask, outer_first_mpls_over_gre_ttl);
+	} else {
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_label,
+				  misc_2_mask, outer_first_mpls_over_udp_label);
+
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_exp,
+				  misc_2_mask, outer_first_mpls_over_udp_exp);
+
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_s_bos,
+				  misc_2_mask, outer_first_mpls_over_udp_s_bos);
+
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_ttl,
+				  misc_2_mask, outer_first_mpls_over_udp_ttl);
+	}
+}
+
+static int dr_ste_build_flex_parser_0_tag(struct mlx5dr_match_param *value=
,
+					  struct mlx5dr_ste_build *sb,
+					  u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_misc2 *misc_2_mask =3D &value->misc2;
+	u8 *tag =3D hw_ste->tag;
+
+	if (DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(misc_2_mask)) {
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_label,
+			       misc_2_mask, outer_first_mpls_over_gre_label);
+
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_exp,
+			       misc_2_mask, outer_first_mpls_over_gre_exp);
+
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_s_bos,
+			       misc_2_mask, outer_first_mpls_over_gre_s_bos);
+
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_ttl,
+			       misc_2_mask, outer_first_mpls_over_gre_ttl);
+	} else {
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_label,
+			       misc_2_mask, outer_first_mpls_over_udp_label);
+
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_exp,
+			       misc_2_mask, outer_first_mpls_over_udp_exp);
+
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_s_bos,
+			       misc_2_mask, outer_first_mpls_over_udp_s_bos);
+
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_ttl,
+			       misc_2_mask, outer_first_mpls_over_udp_ttl);
+	}
+	return 0;
+}
+
+void mlx5dr_ste_build_flex_parser_0(struct mlx5dr_ste_build *sb,
+				    struct mlx5dr_match_param *mask,
+				    bool inner, bool rx)
+{
+	dr_ste_build_flex_parser_0_bit_mask(mask, inner, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D MLX5DR_STE_LU_TYPE_FLEX_PARSER_0;
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_flex_parser_0_tag;
+}
+
+#define ICMP_TYPE_OFFSET_FIRST_DW		24
+#define ICMP_CODE_OFFSET_FIRST_DW		16
+#define ICMP_HEADER_DATA_OFFSET_SECOND_DW	0
+
+static int dr_ste_build_flex_parser_1_bit_mask(struct mlx5dr_match_param *=
mask,
+					       struct mlx5dr_cmd_caps *caps,
+					       u8 *bit_mask)
+{
+	struct mlx5dr_match_misc3 *misc_3_mask =3D &mask->misc3;
+	bool is_ipv4_mask =3D DR_MASK_IS_FLEX_PARSER_ICMPV4_SET(misc_3_mask);
+	u32 icmp_header_data_mask;
+	u32 icmp_type_mask;
+	u32 icmp_code_mask;
+	int dw0_location;
+	int dw1_location;
+
+	if (is_ipv4_mask) {
+		icmp_header_data_mask	=3D misc_3_mask->icmpv4_header_data;
+		icmp_type_mask		=3D misc_3_mask->icmpv4_type;
+		icmp_code_mask		=3D misc_3_mask->icmpv4_code;
+		dw0_location		=3D caps->flex_parser_id_icmp_dw0;
+		dw1_location		=3D caps->flex_parser_id_icmp_dw1;
+	} else {
+		icmp_header_data_mask	=3D misc_3_mask->icmpv6_header_data;
+		icmp_type_mask		=3D misc_3_mask->icmpv6_type;
+		icmp_code_mask		=3D misc_3_mask->icmpv6_code;
+		dw0_location		=3D caps->flex_parser_id_icmpv6_dw0;
+		dw1_location		=3D caps->flex_parser_id_icmpv6_dw1;
+	}
+
+	switch (dw0_location) {
+	case 4:
+		if (icmp_type_mask) {
+			MLX5_SET(ste_flex_parser_1, bit_mask, flex_parser_4,
+				 (icmp_type_mask << ICMP_TYPE_OFFSET_FIRST_DW));
+			if (is_ipv4_mask)
+				misc_3_mask->icmpv4_type =3D 0;
+			else
+				misc_3_mask->icmpv6_type =3D 0;
+		}
+		if (icmp_code_mask) {
+			u32 cur_val =3D MLX5_GET(ste_flex_parser_1, bit_mask,
+					       flex_parser_4);
+			MLX5_SET(ste_flex_parser_1, bit_mask, flex_parser_4,
+				 cur_val | (icmp_code_mask << ICMP_CODE_OFFSET_FIRST_DW));
+			if (is_ipv4_mask)
+				misc_3_mask->icmpv4_code =3D 0;
+			else
+				misc_3_mask->icmpv6_code =3D 0;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (dw1_location) {
+	case 5:
+		if (icmp_header_data_mask) {
+			MLX5_SET(ste_flex_parser_1, bit_mask, flex_parser_5,
+				 (icmp_header_data_mask << ICMP_HEADER_DATA_OFFSET_SECOND_DW));
+			if (is_ipv4_mask)
+				misc_3_mask->icmpv4_header_data =3D 0;
+			else
+				misc_3_mask->icmpv6_header_data =3D 0;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int dr_ste_build_flex_parser_1_tag(struct mlx5dr_match_param *value=
,
+					  struct mlx5dr_ste_build *sb,
+					  u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_misc3 *misc_3 =3D &value->misc3;
+	u8 *tag =3D hw_ste->tag;
+	u32 icmp_header_data;
+	int dw0_location;
+	int dw1_location;
+	u32 icmp_type;
+	u32 icmp_code;
+	bool is_ipv4;
+
+	is_ipv4 =3D DR_MASK_IS_FLEX_PARSER_ICMPV4_SET(misc_3);
+	if (is_ipv4) {
+		icmp_header_data	=3D misc_3->icmpv4_header_data;
+		icmp_type		=3D misc_3->icmpv4_type;
+		icmp_code		=3D misc_3->icmpv4_code;
+		dw0_location		=3D sb->caps->flex_parser_id_icmp_dw0;
+		dw1_location		=3D sb->caps->flex_parser_id_icmp_dw1;
+	} else {
+		icmp_header_data	=3D misc_3->icmpv6_header_data;
+		icmp_type		=3D misc_3->icmpv6_type;
+		icmp_code		=3D misc_3->icmpv6_code;
+		dw0_location		=3D sb->caps->flex_parser_id_icmpv6_dw0;
+		dw1_location		=3D sb->caps->flex_parser_id_icmpv6_dw1;
+	}
+
+	switch (dw0_location) {
+	case 4:
+		if (icmp_type) {
+			MLX5_SET(ste_flex_parser_1, tag, flex_parser_4,
+				 (icmp_type << ICMP_TYPE_OFFSET_FIRST_DW));
+			if (is_ipv4)
+				misc_3->icmpv4_type =3D 0;
+			else
+				misc_3->icmpv6_type =3D 0;
+		}
+
+		if (icmp_code) {
+			u32 cur_val =3D MLX5_GET(ste_flex_parser_1, tag,
+					       flex_parser_4);
+			MLX5_SET(ste_flex_parser_1, tag, flex_parser_4,
+				 cur_val | (icmp_code << ICMP_CODE_OFFSET_FIRST_DW));
+			if (is_ipv4)
+				misc_3->icmpv4_code =3D 0;
+			else
+				misc_3->icmpv6_code =3D 0;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (dw1_location) {
+	case 5:
+		if (icmp_header_data) {
+			MLX5_SET(ste_flex_parser_1, tag, flex_parser_5,
+				 (icmp_header_data << ICMP_HEADER_DATA_OFFSET_SECOND_DW));
+			if (is_ipv4)
+				misc_3->icmpv4_header_data =3D 0;
+			else
+				misc_3->icmpv6_header_data =3D 0;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int mlx5dr_ste_build_flex_parser_1(struct mlx5dr_ste_build *sb,
+				   struct mlx5dr_match_param *mask,
+				   struct mlx5dr_cmd_caps *caps,
+				   bool inner, bool rx)
+{
+	int ret;
+
+	ret =3D dr_ste_build_flex_parser_1_bit_mask(mask, caps, sb->bit_mask);
+	if (ret)
+		return ret;
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->caps =3D caps;
+	sb->lu_type =3D MLX5DR_STE_LU_TYPE_FLEX_PARSER_1;
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_flex_parser_1_tag;
+
+	return 0;
+}
+
+static void dr_ste_build_general_purpose_bit_mask(struct mlx5dr_match_para=
m *value,
+						  bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_misc2 *misc_2_mask =3D &value->misc2;
+
+	DR_STE_SET_MASK_V(general_purpose, bit_mask,
+			  general_purpose_lookup_field, misc_2_mask,
+			  metadata_reg_a);
+}
+
+static int dr_ste_build_general_purpose_tag(struct mlx5dr_match_param *val=
ue,
+					    struct mlx5dr_ste_build *sb,
+					    u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_misc2 *misc_2_mask =3D &value->misc2;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(general_purpose, tag, general_purpose_lookup_field,
+		       misc_2_mask, metadata_reg_a);
+
+	return 0;
+}
+
+void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_build *sb,
+				      struct mlx5dr_match_param *mask,
+				      bool inner, bool rx)
+{
+	dr_ste_build_general_purpose_bit_mask(mask, inner, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D MLX5DR_STE_LU_TYPE_GENERAL_PURPOSE;
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_general_purpose_tag;
+}
+
+static void dr_ste_build_eth_l4_misc_bit_mask(struct mlx5dr_match_param *v=
alue,
+					      bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_misc3 *misc_3_mask =3D &value->misc3;
+
+	if (inner) {
+		DR_STE_SET_MASK_V(eth_l4_misc, bit_mask, seq_num, misc_3_mask,
+				  inner_tcp_seq_num);
+		DR_STE_SET_MASK_V(eth_l4_misc, bit_mask, ack_num, misc_3_mask,
+				  inner_tcp_ack_num);
+	} else {
+		DR_STE_SET_MASK_V(eth_l4_misc, bit_mask, seq_num, misc_3_mask,
+				  outer_tcp_seq_num);
+		DR_STE_SET_MASK_V(eth_l4_misc, bit_mask, ack_num, misc_3_mask,
+				  outer_tcp_ack_num);
+	}
+}
+
+static int dr_ste_build_eth_l4_misc_tag(struct mlx5dr_match_param *value,
+					struct mlx5dr_ste_build *sb,
+					u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_misc3 *misc3 =3D &value->misc3;
+	u8 *tag =3D hw_ste->tag;
+
+	if (sb->inner) {
+		DR_STE_SET_TAG(eth_l4_misc, tag, seq_num, misc3, inner_tcp_seq_num);
+		DR_STE_SET_TAG(eth_l4_misc, tag, ack_num, misc3, inner_tcp_ack_num);
+	} else {
+		DR_STE_SET_TAG(eth_l4_misc, tag, seq_num, misc3, outer_tcp_seq_num);
+		DR_STE_SET_TAG(eth_l4_misc, tag, ack_num, misc3, outer_tcp_ack_num);
+	}
+
+	return 0;
+}
+
+void mlx5dr_ste_build_eth_l4_misc(struct mlx5dr_ste_build *sb,
+				  struct mlx5dr_match_param *mask,
+				  bool inner, bool rx)
+{
+	dr_ste_build_eth_l4_misc_bit_mask(mask, inner, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D DR_STE_CALC_LU_TYPE(ETHL4_MISC, rx, inner);
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_eth_l4_misc_tag;
+}
+
+static void dr_ste_build_flex_parser_tnl_bit_mask(struct mlx5dr_match_para=
m *value,
+						  bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_misc3 *misc_3_mask =3D &value->misc3;
+
+	if (misc_3_mask->outer_vxlan_gpe_flags ||
+	    misc_3_mask->outer_vxlan_gpe_next_protocol) {
+		MLX5_SET(ste_flex_parser_tnl, bit_mask,
+			 flex_parser_tunneling_header_63_32,
+			 (misc_3_mask->outer_vxlan_gpe_flags << 24) |
+			 (misc_3_mask->outer_vxlan_gpe_next_protocol));
+		misc_3_mask->outer_vxlan_gpe_flags =3D 0;
+		misc_3_mask->outer_vxlan_gpe_next_protocol =3D 0;
+	}
+
+	if (misc_3_mask->outer_vxlan_gpe_vni) {
+		MLX5_SET(ste_flex_parser_tnl, bit_mask,
+			 flex_parser_tunneling_header_31_0,
+			 misc_3_mask->outer_vxlan_gpe_vni << 8);
+		misc_3_mask->outer_vxlan_gpe_vni =3D 0;
+	}
+}
+
+static int dr_ste_build_flex_parser_tnl_tag(struct mlx5dr_match_param *val=
ue,
+					    struct mlx5dr_ste_build *sb,
+					    u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_misc3 *misc3 =3D &value->misc3;
+	u8 *tag =3D hw_ste->tag;
+
+	if (misc3->outer_vxlan_gpe_flags ||
+	    misc3->outer_vxlan_gpe_next_protocol) {
+		MLX5_SET(ste_flex_parser_tnl, tag,
+			 flex_parser_tunneling_header_63_32,
+			 (misc3->outer_vxlan_gpe_flags << 24) |
+			 (misc3->outer_vxlan_gpe_next_protocol));
+		misc3->outer_vxlan_gpe_flags =3D 0;
+		misc3->outer_vxlan_gpe_next_protocol =3D 0;
+	}
+
+	if (misc3->outer_vxlan_gpe_vni) {
+		MLX5_SET(ste_flex_parser_tnl, tag,
+			 flex_parser_tunneling_header_31_0,
+			 misc3->outer_vxlan_gpe_vni << 8);
+		misc3->outer_vxlan_gpe_vni =3D 0;
+	}
+
+	return 0;
+}
+
+void mlx5dr_ste_build_flex_parser_tnl(struct mlx5dr_ste_build *sb,
+				      struct mlx5dr_match_param *mask,
+				      bool inner, bool rx)
+{
+	dr_ste_build_flex_parser_tnl_bit_mask(mask, inner, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER;
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_flex_parser_tnl_tag;
+}
+
+static void dr_ste_build_register_0_bit_mask(struct mlx5dr_match_param *va=
lue,
+					     u8 *bit_mask)
+{
+	struct mlx5dr_match_misc2 *misc_2_mask =3D &value->misc2;
+
+	DR_STE_SET_MASK_V(register_0, bit_mask, register_0_h,
+			  misc_2_mask, metadata_reg_c_0);
+	DR_STE_SET_MASK_V(register_0, bit_mask, register_0_l,
+			  misc_2_mask, metadata_reg_c_1);
+	DR_STE_SET_MASK_V(register_0, bit_mask, register_1_h,
+			  misc_2_mask, metadata_reg_c_2);
+	DR_STE_SET_MASK_V(register_0, bit_mask, register_1_l,
+			  misc_2_mask, metadata_reg_c_3);
+}
+
+static int dr_ste_build_register_0_tag(struct mlx5dr_match_param *value,
+				       struct mlx5dr_ste_build *sb,
+				       u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_misc2 *misc2 =3D &value->misc2;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(register_0, tag, register_0_h, misc2, metadata_reg_c_0);
+	DR_STE_SET_TAG(register_0, tag, register_0_l, misc2, metadata_reg_c_1);
+	DR_STE_SET_TAG(register_0, tag, register_1_h, misc2, metadata_reg_c_2);
+	DR_STE_SET_TAG(register_0, tag, register_1_l, misc2, metadata_reg_c_3);
+
+	return 0;
+}
+
+void mlx5dr_ste_build_register_0(struct mlx5dr_ste_build *sb,
+				 struct mlx5dr_match_param *mask,
+				 bool inner, bool rx)
+{
+	dr_ste_build_register_0_bit_mask(mask, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_0;
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_register_0_tag;
+}
+
+static void dr_ste_build_register_1_bit_mask(struct mlx5dr_match_param *va=
lue,
+					     u8 *bit_mask)
+{
+	struct mlx5dr_match_misc2 *misc_2_mask =3D &value->misc2;
+
+	DR_STE_SET_MASK_V(register_1, bit_mask, register_2_h,
+			  misc_2_mask, metadata_reg_c_4);
+	DR_STE_SET_MASK_V(register_1, bit_mask, register_2_l,
+			  misc_2_mask, metadata_reg_c_5);
+	DR_STE_SET_MASK_V(register_1, bit_mask, register_3_h,
+			  misc_2_mask, metadata_reg_c_6);
+	DR_STE_SET_MASK_V(register_1, bit_mask, register_3_l,
+			  misc_2_mask, metadata_reg_c_7);
+}
+
+static int dr_ste_build_register_1_tag(struct mlx5dr_match_param *value,
+				       struct mlx5dr_ste_build *sb,
+				       u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_misc2 *misc2 =3D &value->misc2;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(register_1, tag, register_2_h, misc2, metadata_reg_c_4);
+	DR_STE_SET_TAG(register_1, tag, register_2_l, misc2, metadata_reg_c_5);
+	DR_STE_SET_TAG(register_1, tag, register_3_h, misc2, metadata_reg_c_6);
+	DR_STE_SET_TAG(register_1, tag, register_3_l, misc2, metadata_reg_c_7);
+
+	return 0;
+}
+
+void mlx5dr_ste_build_register_1(struct mlx5dr_ste_build *sb,
+				 struct mlx5dr_match_param *mask,
+				 bool inner, bool rx)
+{
+	dr_ste_build_register_1_bit_mask(mask, sb->bit_mask);
+
+	sb->rx =3D rx;
+	sb->inner =3D inner;
+	sb->lu_type =3D MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_1;
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_register_1_tag;
+}
+
+static int dr_ste_build_src_gvmi_qpn_bit_mask(struct mlx5dr_match_param *v=
alue,
+					      u8 *bit_mask)
+{
+	struct mlx5dr_match_misc *misc_mask =3D &value->misc;
+
+	if (misc_mask->source_port !=3D 0xffff)
+		return -EINVAL;
+
+	DR_STE_SET_MASK(src_gvmi_qp, bit_mask, source_gvmi, misc_mask, source_por=
t);
+	DR_STE_SET_MASK(src_gvmi_qp, bit_mask, source_qp, misc_mask, source_sqn);
+
+	return 0;
+}
+
+static int dr_ste_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
+					 struct mlx5dr_ste_build *sb,
+					 u8 *hw_ste_p)
+{
+	struct dr_hw_ste_format *hw_ste =3D (struct dr_hw_ste_format *)hw_ste_p;
+	struct mlx5dr_match_misc *misc =3D &value->misc;
+	struct mlx5dr_cmd_vport_cap *vport_cap;
+	u8 *tag =3D hw_ste->tag;
+
+	DR_STE_SET_TAG(src_gvmi_qp, tag, source_qp, misc, source_sqn);
+
+	vport_cap =3D mlx5dr_get_vport_cap(sb->caps, misc->source_port);
+	if (!vport_cap)
+		return -EINVAL;
+
+	if (vport_cap->vport_gvmi)
+		MLX5_SET(ste_src_gvmi_qp, tag, source_gvmi, vport_cap->vport_gvmi);
+
+	misc->source_port =3D 0;
+
+	return 0;
+}
+
+int mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_build *sb,
+				  struct mlx5dr_match_param *mask,
+				  struct mlx5dr_cmd_caps *caps,
+				  bool inner, bool rx)
+{
+	int ret;
+
+	ret =3D dr_ste_build_src_gvmi_qpn_bit_mask(mask, sb->bit_mask);
+	if (ret)
+		return ret;
+
+	sb->rx =3D rx;
+	sb->caps =3D caps;
+	sb->inner =3D inner;
+	sb->lu_type =3D MLX5DR_STE_LU_TYPE_SRC_GVMI_AND_QP;
+	sb->byte_mask =3D dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func =3D &dr_ste_build_src_gvmi_qpn_tag;
+
+	return 0;
+}
--=20
2.21.0

