Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757F120C441
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgF0VS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:18:58 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:16519
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbgF0VS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:18:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+F7ppoNs5YWIooBLn+iPzmQGE5AoyAbSiloAL978TpdBL6sTRAGLHf9bV8vJdlGG96SaCWjLUGSavIyRE8KM6a4dQRVzsBW4dZrHrgqxP4Pjm3YoHF0XToHLTYjM5lWY3dXMn1iBVBxwOrkzETt5BXjcY6TeuFIHgIeHqwkZ7PMzNFwbznq+XuMP5aaZX4RkpQaUsTrFINPpzWiRW4Gn04kv6hmH4Jz7/GmjizeCpl38p6qgN36xZNhWfrBQTqtXPVS7m34mDQelm18pzqvlJqwygUPWRWFmqZc+NpalPBY5jZjXKGGN3XcfPLCxPkVpnazDYHOMEYHLWz0McygCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5dSNaot+DwlnQLjnePK9OGTL37zZEONp+wD0plwSe8=;
 b=gdzyTQzpi5ERzT+mPBsEzWJi25Vst/IIPu5WIVD3DbMx1DgjjE8ISZX+nlOE2kOt/CpXsAWzvfTvzdIDL/8cyx2huEyAL2TQlIphvbhN5aQdEY9RFkoUWP2K7Rg9U/ITtWaxPNlMsyuhIHZwT2mY12Tomkv+NQ3/On4CPRgHxiAN9CqQoErlV+XjxomXZZx/401a2uz4DE2vPkHJYHpf6vrgdLBbOrqpizoOpNk1NPqHOdyniUdOIbiGzWozQeklGcSuQjlblGuVddJevpHJ7cRpZ7nWsaJh6Y5A7rwx9nBt72Ofn50gJ6NYBhTel3I0SgfiDcEH51/q7/noYXRksw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5dSNaot+DwlnQLjnePK9OGTL37zZEONp+wD0plwSe8=;
 b=DLcRrG0dDRGzj66FEHiu+lWcL8+9RPjsy6AQ4yaIcNkpKTTUDOF/tz9lGiL50gzfSJbLxzTzbXo3qtcU3iJlAjs2VpOS9APG/AEAPzMdIVZGnox/Tbz0CQkKWM1u6KcT0wrQi48Z8JiA+kAxClaOv3WR5Xluz+SzptCexEZcuL0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:18:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:18:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Boris Pismenny <borisp@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/15] net/mlx5e: Receive flow steering framework for accelerated TCP flows
Date:   Sat, 27 Jun 2020 14:17:16 -0700
Message-Id: <20200627211727.259569-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627211727.259569-1-saeedm@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:18:42 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 934f7be8-d8fe-41ee-d1cf-08d81adfac17
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5134A4D69239B71F52071F39BE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:530;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fQCY3cDeZF6tEOFGEC278oMvivFk0Uki1SOaWe+wfRnVnSyS+PusjXUhGGrtdgMAXIyzQp23VEZ4HiN5TiPjhioVw8gqQYEajhOnm3KWWCGZP2J/U3NPTvC8QRiCA0XTwXOO8ePTG04Ggf8Uuo037Dj93b3HqsCZqtffL/7LnhVvPk5U6OuPQunmQgz+63sUqsrk05nyhA6Flu+jO+yd3zp7AfGMN+hAaycZZKbL6RLPObFXR2hNaBwzjh/+0SJ2Tw4+FTsNOCMWMoqQLcO4rb5Id0nV/DcmH6p8WOtKCXIPzGjQ0oEykohO38zBJkSpioOBvdfPoNAFc4ca9mw4aibwhFgYQu03KELMeslRePaG7NkIFGfBjaKr4+Rc8x8W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(30864003)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: veK3PP8fJ01Xb1rABCQ7GG7ctDAMGOFM296Xb2+DegwrqNDESmGpsX8wW+Veuajxu9tRW+tePuNhK7UVm9Pej6REnu9Ysp7FD6BebzVpX5ilXTxeQUVSmoYt82JGE0uxPhF7r31WVm+2LCSQ/LgAzH0Ity/sTVupj6ZSPVT0yxz0yg0579RWnDWnPr4zVr1hgN/rnfi+9RQTZmWtrb+dhHhkkMZIvaL+WN3Pf3g6kTl84lDHAQ//XtMmHvodeuWCW59WoErscmgu5Xu0Xpvb1fOC4cYTAUtUYD66P76L2z1DjBX3TbpYMWpaCxmuPSZ90/E/7esd1INPyLeYX3v9f4QMKwfXqIKzePWUgTqWyT7+NamZz3D+TBFL1jWQIe9WjcunKJDQeaJ4C8+0G7W/CZmcyFwQ362/kivaDuDMnppRMHoliOfib+K0DFtkI6ibU42xrrHKx9kaHIsoNwiq9OScnkzViOaABwtVqj+AH+8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 934f7be8-d8fe-41ee-d1cf-08d81adfac17
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:18:44.4084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QRIIAS8WLxrRgX9BU3y8b1qWlGXM13kyTx3trsNUG0ZeM2rjI9RB+qKK/oSwWEHgEmz3PM7ZuKk5wK9dkGIzhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>

The framework allows creating flow tables to steer incoming traffic of
TCP sockets to the acceleration TIRs.
This is used in downstream patches for TLS, and will be used in the
future for other offloads.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  10 +
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      | 280 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/fs_tcp.h      |  18 ++
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   4 +-
 5 files changed, 311 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index b61e47bc16e8..8ffa1325a18f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -74,7 +74,7 @@ mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
 				     en_accel/ipsec_stats.o
 
 mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/tls.o en_accel/tls_rxtx.o en_accel/tls_stats.o \
-				   en_accel/ktls.o en_accel/ktls_tx.o
+				   en_accel/ktls.o en_accel/ktls_tx.o en_accel/fs_tcp.o
 
 mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o \
 					steering/dr_matcher.o steering/dr_rule.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index c633579474c3..385cbff1caf1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -123,6 +123,9 @@ enum {
 	MLX5E_L2_FT_LEVEL,
 	MLX5E_TTC_FT_LEVEL,
 	MLX5E_INNER_TTC_FT_LEVEL,
+#ifdef CONFIG_MLX5_EN_TLS
+	MLX5E_ACCEL_FS_TCP_FT_LEVEL,
+#endif
 #ifdef CONFIG_MLX5_EN_ARFS
 	MLX5E_ARFS_FT_LEVEL
 #endif
@@ -216,6 +219,10 @@ static inline int mlx5e_arfs_enable(struct mlx5e_priv *priv) { return -EOPNOTSUP
 static inline int mlx5e_arfs_disable(struct mlx5e_priv *priv) {	return -EOPNOTSUPP; }
 #endif
 
+#ifdef CONFIG_MLX5_EN_TLS
+struct mlx5e_accel_fs_tcp;
+#endif
+
 struct mlx5e_flow_steering {
 	struct mlx5_flow_namespace      *ns;
 #ifdef CONFIG_MLX5_EN_RXNFC
@@ -229,6 +236,9 @@ struct mlx5e_flow_steering {
 #ifdef CONFIG_MLX5_EN_ARFS
 	struct mlx5e_arfs_tables        arfs;
 #endif
+#ifdef CONFIG_MLX5_EN_TLS
+	struct mlx5e_accel_fs_tcp      *accel_tcp;
+#endif
 };
 
 struct ttc_params {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
new file mode 100644
index 000000000000..a0e9082e15b0
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -0,0 +1,280 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+
+#include <linux/netdevice.h>
+#include "en_accel/fs_tcp.h"
+#include "fs_core.h"
+
+enum accel_fs_tcp_type {
+	ACCEL_FS_IPV4_TCP,
+	ACCEL_FS_IPV6_TCP,
+	ACCEL_FS_TCP_NUM_TYPES,
+};
+
+struct mlx5e_accel_fs_tcp {
+	struct mlx5e_flow_table tables[ACCEL_FS_TCP_NUM_TYPES];
+	struct mlx5_flow_handle *default_rules[ACCEL_FS_TCP_NUM_TYPES];
+};
+
+static enum mlx5e_traffic_types fs_accel2tt(enum accel_fs_tcp_type i)
+{
+	switch (i) {
+	case ACCEL_FS_IPV4_TCP:
+		return MLX5E_TT_IPV4_TCP;
+	default: /* ACCEL_FS_IPV6_TCP */
+		return MLX5E_TT_IPV6_TCP;
+	}
+}
+
+static int accel_fs_tcp_add_default_rule(struct mlx5e_priv *priv,
+					 enum accel_fs_tcp_type type)
+{
+	struct mlx5e_flow_table *accel_fs_t;
+	struct mlx5_flow_destination dest;
+	struct mlx5e_accel_fs_tcp *fs_tcp;
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_handle *rule;
+	int err = 0;
+
+	fs_tcp = priv->fs.accel_tcp;
+	accel_fs_t = &fs_tcp->tables[type];
+
+	dest = mlx5e_ttc_get_default_dest(priv, fs_accel2tt(type));
+	rule = mlx5_add_flow_rules(accel_fs_t->t, NULL, &flow_act, &dest, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		netdev_err(priv->netdev,
+			   "%s: add default rule failed, accel_fs type=%d, err %d\n",
+			   __func__, type, err);
+		return err;
+	}
+
+	fs_tcp->default_rules[type] = rule;
+	return 0;
+}
+
+#define MLX5E_ACCEL_FS_TCP_NUM_GROUPS	(2)
+#define MLX5E_ACCEL_FS_TCP_GROUP1_SIZE	(BIT(16) - 1)
+#define MLX5E_ACCEL_FS_TCP_GROUP2_SIZE	(BIT(0))
+#define MLX5E_ACCEL_FS_TCP_TABLE_SIZE	(MLX5E_ACCEL_FS_TCP_GROUP1_SIZE +\
+					 MLX5E_ACCEL_FS_TCP_GROUP2_SIZE)
+static int accel_fs_tcp_create_groups(struct mlx5e_flow_table *ft,
+				      enum accel_fs_tcp_type type)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	void *outer_headers_c;
+	int ix = 0;
+	u32 *in;
+	int err;
+	u8 *mc;
+
+	ft->g = kcalloc(MLX5E_ACCEL_FS_TCP_NUM_GROUPS, sizeof(*ft->g), GFP_KERNEL);
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if  (!in || !ft->g) {
+		kvfree(ft->g);
+		kvfree(in);
+		return -ENOMEM;
+	}
+
+	mc = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+	outer_headers_c = MLX5_ADDR_OF(fte_match_param, mc, outer_headers);
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, ip_protocol);
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, ip_version);
+
+	switch (type) {
+	case ACCEL_FS_IPV4_TCP:
+	case ACCEL_FS_IPV6_TCP:
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, tcp_dport);
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, tcp_sport);
+		break;
+	default:
+		err = -EINVAL;
+		goto out;
+	}
+
+	switch (type) {
+	case ACCEL_FS_IPV4_TCP:
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c,
+				 src_ipv4_src_ipv6.ipv4_layout.ipv4);
+		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c,
+				 dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
+		break;
+	case ACCEL_FS_IPV6_TCP:
+		memset(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
+				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+		       0xff, 16);
+		memset(MLX5_ADDR_OF(fte_match_set_lyr_2_4, outer_headers_c,
+				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+		       0xff, 16);
+		break;
+	default:
+		err = -EINVAL;
+		goto out;
+	}
+
+	MLX5_SET_CFG(in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += MLX5E_ACCEL_FS_TCP_GROUP1_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
+	if (IS_ERR(ft->g[ft->num_groups]))
+		goto err;
+	ft->num_groups++;
+
+	/* Default Flow Group */
+	memset(in, 0, inlen);
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += MLX5E_ACCEL_FS_TCP_GROUP2_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
+	if (IS_ERR(ft->g[ft->num_groups]))
+		goto err;
+	ft->num_groups++;
+
+	kvfree(in);
+	return 0;
+
+err:
+	err = PTR_ERR(ft->g[ft->num_groups]);
+	ft->g[ft->num_groups] = NULL;
+out:
+	kvfree(in);
+
+	return err;
+}
+
+static int accel_fs_tcp_create_table(struct mlx5e_priv *priv, enum accel_fs_tcp_type type)
+{
+	struct mlx5e_flow_table *ft = &priv->fs.accel_tcp->tables[type];
+	struct mlx5_flow_table_attr ft_attr = {};
+	int err;
+
+	ft->num_groups = 0;
+
+	ft_attr.max_fte = MLX5E_ACCEL_FS_TCP_TABLE_SIZE;
+	ft_attr.level = MLX5E_ACCEL_FS_TCP_FT_LEVEL;
+	ft_attr.prio = MLX5E_NIC_PRIO;
+
+	ft->t = mlx5_create_flow_table(priv->fs.ns, &ft_attr);
+	if (IS_ERR(ft->t)) {
+		err = PTR_ERR(ft->t);
+		ft->t = NULL;
+		return err;
+	}
+
+	netdev_dbg(priv->netdev, "Created fs accel table id %u level %u\n",
+		   ft->t->id, ft->t->level);
+
+	err = accel_fs_tcp_create_groups(ft, type);
+	if (err)
+		goto err;
+
+	err = accel_fs_tcp_add_default_rule(priv, type);
+	if (err)
+		goto err;
+
+	return 0;
+err:
+	mlx5e_destroy_flow_table(ft);
+	return err;
+}
+
+static int accel_fs_tcp_disable(struct mlx5e_priv *priv)
+{
+	int err, i;
+
+	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++) {
+		/* Modify ttc rules destination to point back to the indir TIRs */
+		err = mlx5e_ttc_fwd_default_dest(priv, fs_accel2tt(i));
+		if (err) {
+			netdev_err(priv->netdev,
+				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
+				   __func__, fs_accel2tt(i), err);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int accel_fs_tcp_enable(struct mlx5e_priv *priv)
+{
+	struct mlx5_flow_destination dest = {};
+	int err, i;
+
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++) {
+		dest.ft = priv->fs.accel_tcp->tables[i].t;
+
+		/* Modify ttc rules destination to point on the accel_fs FTs */
+		err = mlx5e_ttc_fwd_dest(priv, fs_accel2tt(i), &dest);
+		if (err) {
+			netdev_err(priv->netdev,
+				   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
+				   __func__, fs_accel2tt(i), err);
+			return err;
+		}
+	}
+	return 0;
+}
+
+static void accel_fs_tcp_destroy_table(struct mlx5e_priv *priv, int i)
+{
+	struct mlx5e_accel_fs_tcp *fs_tcp;
+
+	fs_tcp = priv->fs.accel_tcp;
+	if (IS_ERR_OR_NULL(fs_tcp->tables[i].t))
+		return;
+
+	mlx5_del_flow_rules(fs_tcp->default_rules[i]);
+	mlx5e_destroy_flow_table(&fs_tcp->tables[i]);
+	fs_tcp->tables[i].t = NULL;
+}
+
+void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv)
+{
+	int i;
+
+	if (!priv->fs.accel_tcp)
+		return;
+
+	accel_fs_tcp_disable(priv);
+
+	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
+		accel_fs_tcp_destroy_table(priv, i);
+
+	kfree(priv->fs.accel_tcp);
+	priv->fs.accel_tcp = NULL;
+}
+
+int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv)
+{
+	int i, err;
+
+	if (!MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ft_field_support.outer_ip_version))
+		return -EOPNOTSUPP;
+
+	priv->fs.accel_tcp = kzalloc(sizeof(*priv->fs.accel_tcp), GFP_KERNEL);
+	if (!priv->fs.accel_tcp)
+		return -ENOMEM;
+
+	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++) {
+		err = accel_fs_tcp_create_table(priv, i);
+		if (err)
+			goto err_destroy_tables;
+	}
+
+	err = accel_fs_tcp_enable(priv);
+	if (err)
+		goto err_destroy_tables;
+
+	return 0;
+
+err_destroy_tables:
+	while (--i >= 0)
+		accel_fs_tcp_destroy_table(priv, i);
+
+	kfree(priv->fs.accel_tcp);
+	priv->fs.accel_tcp = NULL;
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
new file mode 100644
index 000000000000..0df53473550a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
+
+#ifndef __MLX5E_ACCEL_FS_TCP_H__
+#define __MLX5E_ACCEL_FS_TCP_H__
+
+#include "en.h"
+
+#ifdef CONFIG_MLX5_EN_TLS
+int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv);
+void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv);
+#else
+static inline int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv) { return 0; }
+static inline void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv) {}
+#endif
+
+#endif /* __MLX5E_ACCEL_FS_TCP_H__ */
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index e47a66983935..785b2960d6b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -105,8 +105,8 @@
 #define ETHTOOL_PRIO_NUM_LEVELS 1
 #define ETHTOOL_NUM_PRIOS 11
 #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
-/* Vlan, mac, ttc, inner ttc, aRFS */
-#define KERNEL_NIC_PRIO_NUM_LEVELS 5
+/* Vlan, mac, ttc, inner ttc, {aRFS/accel} */
+#define KERNEL_NIC_PRIO_NUM_LEVELS 6
 #define KERNEL_NIC_NUM_PRIOS 1
 /* One more level for tc */
 #define KERNEL_MIN_LEVEL (KERNEL_NIC_PRIO_NUM_LEVELS + 1)
-- 
2.26.2

