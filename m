Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28001E8823
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgE2TrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:47:24 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:57981
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726077AbgE2TrX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:47:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MiSrK4zB42qe04U6HnFVis10WWGrpWxBftK4Itl44Gd3C6oliG7B1j5kABVqkPVyUHgEOxedYa7jQyamL8X3hMKnWHOg3lTEpeIX6TPYxT1A7Ej8arMmNLAEk+UHxsyH77fM+8CuBeM4ZKHJHnQSMwGfRJXuORv8n8oaaYmDw3IScezF8CbzRQhh1SegXHUeqAP31MPUuKlYSH82lQX2/L2vhEn8eUkeTRzUjg32gQS5ph+CgSqbB1jSBNqM1JvKCEMpSulgHh2o1etRYYg9l0PDrjljUww732/0cy5Qu1yP+oR230aH4yPbeRJG4u5Ge6wsJI+VDFNYaB4HGdixZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQAZIaPtGFYDJ5BCrqSfE20+uCS96T+slWajfPaXLPA=;
 b=I7DEpa3qEEwWSaTjAfTx5yUqk0xHbaqVQRJ0uQr3npWIHAQU4HXeaS3kqa14aEf2knEBBdn3l842g0sg2JO2v4gjOlh3atCd13Ac5NFmSPA8j1WrVwUWM2PYoaKDXMB54+XSt62jieG/c68gFaVWp+oQYI7GmHnPSjbnq3KfEnDZAj/efea1HPLvR0SXn2Cb6k/AnrTHTv/2PrFO0i/+/VIwf/AoaJqtNdkemBTWLQlwb5axHPzXdHObMebwltMQlqAzVJ+u0/QcpAAPUtSwG+fQmdVPcko0nrWfSNm4it5EOD/8FMycBABhppnZZ7hRDxMR/SSNsqcGrMkC3QbkoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQAZIaPtGFYDJ5BCrqSfE20+uCS96T+slWajfPaXLPA=;
 b=VCYJ7WvwSoq9IDF3zKLOqfB2obT+r6tE+brtO3kL8RNhB96ctyEqGxfrHh9I/FgLgrfRTiWYQ6RPz6pxIsSxkp96htXjhVwmEBO+rgu2k8tFIGJ50XlGtKTtSi0hFbnoJ4eAvRoAijVvT1BFJFqX82+CuV63Ym2psmw5M2zSZ2Q=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6589.eurprd05.prod.outlook.com (2603:10a6:803:f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 19:47:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 19:47:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Boris Pismenny <borisp@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/11] net/mlx5e: Receive flow steering framework for accelerated TCP flows
Date:   Fri, 29 May 2020 12:46:34 -0700
Message-Id: <20200529194641.243989-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529194641.243989-1-saeedm@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0010.namprd16.prod.outlook.com (2603:10b6:a03:1a0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 19:47:09 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 49151f8e-1407-415c-3318-08d804091407
X-MS-TrafficTypeDiagnostic: VI1PR05MB6589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6589AAC92FCE04112CDC70F2BE8F0@VI1PR05MB6589.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:530;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KLmTlHzCI5losOSjU0jNHoneqzkeRhjfRqNP7uXuFb+GwYNnPYLEbh7wlpH2IwykrArO9ZWpQqWQVxo8T/ogN7Iw8EGg7w1+1kMVm40kCEVCPfvKc9zAsFgwDGJvW1cYE0PydUiZubJi5iKdhFTC9mKWxI7hG9mekDLhj/qmc37rdCiUvSSW63iHdnIjjtOd4rC2NhPQDdjrzjqhT0wCTX258/UuWXLx9qAwmly6Nm+HOgUyACsNx+pe44Kz9AyKSrXbumY/b4Krz8Rstpldlj/mienEHbPbtrt64Udj4yHN4t718ELUcMAWCMt0a59WSrQiKiCL2p6qO/pwFIUUuFkEZEPb0ECQenqVHmV2Yu19Ts3oG/2mSWi4NBIedIpS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(6512007)(83380400001)(36756003)(186003)(4326008)(86362001)(8936002)(26005)(107886003)(16526019)(6506007)(316002)(52116002)(8676002)(2616005)(956004)(54906003)(6666004)(478600001)(66556008)(5660300002)(2906002)(6486002)(1076003)(30864003)(66476007)(66946007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: e3bwo4du3krPLSLg+4bEVd/Io3drTi3PsOPJYlDz8fSeU0uCpAgsEa3Lejz4n3/8VTbfyrcLwIv+MVQ0KcEetZ7GFiMNvPhjmCue9dqia9seKozxXmJULT9xtuhsWBn+4WWv4loNVgbyjWZnqNCylNlP59xC37FqaAKuP/+GUEcZmoZickrL06jbP+9PfACuO0b+3bUP0Sgegw5jUTCT109AQj2qnSNoapkqAD848dk/JC6GuL2C8kJKa+24HX/7Zq6CpgTU9Mm00PmSNqbIJ/iTrfiDwsHvNq9k+w4t+HLR8HZbxji1EGkrx7/5y1uDwXQnVa400ZvSmAnaEZ//cnCjBjnxwPse7HJn2vJIq9qyWq9/+/lTf0bDom0nna5i/cMGh3lJzCA3+LDwAU3rg4hcZ2nwm3mCXMLXGE5c7dmYOLr7bdfni5rqF3aBdnjYKma8w3crnk7WS81jveSiiDz80lX7M5iU32tWrNk5/IQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49151f8e-1407-415c-3318-08d804091407
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 19:47:11.3836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /FiNXt27mDeHQZqcuhQ28QikQZhrKu7UnZxt53eL/5P5jMACiuQ9PKKg2eEAnHyCfDqpGGQ3yMv2TRETP0Edfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6589
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
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      | 275 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/fs_tcp.h      |  18 ++
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   4 +-
 5 files changed, 306 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index b61e47bc16e84..8ffa1325a18f9 100644
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
index c633579474c34..385cbff1caf1d 100644
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
index 0000000000000..882ea296e7eec
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -0,0 +1,275 @@
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
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, ethertype);
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
index 0000000000000..0df53473550af
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
index 4bebbecb078d2..c3c111fb1c817 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -106,8 +106,8 @@
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

