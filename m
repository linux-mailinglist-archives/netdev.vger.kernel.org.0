Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABDD1E52D8
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgE1BUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:20:19 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:34369
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726074AbgE1BUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:20:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUrie0bmO0c6yqMSAtcvVQLgRGoyW9Y4MPcb9dQvQ0Z+geqrKYIwxgEtnPk08gUQY8jTzdTEXAfYC3LngCOipTZrPNmM42p6KlNP7w61AHK3SJvWGwk4WzfaMTW+DFFbrltxIp3oHrjBWgjXNWXqFqShV14aMSMzgo6XfPOFfhnCpA3mW8aMaBApmD4+ZBhrXAR/pGmLz/7lNXiHpruTXXZzZ6sa9UkZGPwCcEvq/Z1YcIQqNC6H9XwFdVzvicVN6ck4KiJIvKG2prtYtyctRyssu5/JXpB/FIUBfvRPwFplwNp/+CYoujF2cNRCgKCJ0/7Zy8rkcIRMPyOijqZpnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXjqbz8Xea0CVEyOkRrRQEyYzoJTc4bZqEwvj7ivoP4=;
 b=NyQf3yoew+qSa3NrdLEjxVTgfGNyOoT3ecjMTJOPTHsIO4PRg+e/Te+OsC3opgic0G3Cgfj/UqoM4OZUPLX7UC6QVG2g5BTGF2NN0Yebz4LQ+ehTb3M9QtW7CxitLtCddu4Uq+8uZwZAvvSiwXDQMmhS3V1xd3iiDPYb0OK/xot1RrrZ5oWSuPdh6JUe0pA1LSs9/ktv6VvLUfgt2QSze0cSOVoH/0KLCFRakt+0sGKLaJ+DwbfB6D8IN1muEj9AQSiPjFVBJPtyVPiEo+dugyTNk5+rGseQ9eGDArKDl7caFf73p+dTw2NRY4VJenBGxk5NpfRu4bkfhsH4tTwGVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXjqbz8Xea0CVEyOkRrRQEyYzoJTc4bZqEwvj7ivoP4=;
 b=Nlz8il/S9bDfkiW5AZPdBt1XmnUCCYeuVILFRYIDAsMHc7bbFyuBZFByIKu9Z4HZj7gKM6ydZZrQ1jh6NzD44YMoOETxwlBc3e4PUQ5xdj/D3ny0iDB/ymgm0wUBEoTqawQuI/5aJAEVqnoDkwYuYbW/UhtilI0cStQRfeIRkGs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:17:29 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:17:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 02/15] net/mlx5: E-Switch, Refactor eswitch ingress acl codes
Date:   Wed, 27 May 2020 18:16:43 -0700
Message-Id: <20200528011656.559914-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528011656.559914-1-saeedm@mellanox.com>
References: <20200528011656.559914-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:27 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0bfffeee-047f-43f5-d9d0-08d802a4e39d
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4368D14F160C9B30110DAA6FBE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cPwZlD9Uorfb8B1W3+Q99T62kpRoqOFbLo8TXgX8ew43vwxvwhGxe4UOzojYBntGCvaOed9dVP+ihwzJL0RBW71SUOAjPvQyRnCLokPzVl0FnO9FzouNOzbGesbtpNkHc8luKaAEP1myUL6byTSyWJkgyMgfjgweZHlZDYt5fPoiW+st5y0bE6g1L44NOh2HbBBzXERD+mAZ60HuXmXmH/0YbJfWJ6H5T6llqi7kvj8Ao23R4b8vPt3EaEDKoiv9jYbfcmlUdWA6TDjeTduvh+RospJSyvakBKEnQ6iS8u/5Qapt1Jn1Otzi8LfZqHvxjwpiHlGO4crvySY6SY1KLCICbPHr3CzX7C9gCTsz2Fva5pBpDw63hBQA8TUDGhZX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(54906003)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(30864003)(6666004)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(186003)(6512007)(54420400002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Dtx4aGK5lZUZKzfc9/SspMd1SfnyAno3GUeoE2PgMn9gu/IMM7UGsaN8bpoTdVhGjsFT+y2LqFRjuISvNL1+mPi1HqRw4A4N3z7+okzrZMQFWazcPYFLpn5bUO7ZrQosTzTifPkwNPfaoGotIZcRmYEmRltUubG/pMn34BbM5xNeK5/UJ95ZCK9B8LtcFOgC2mHBG0Cbih8WOkIQXxVh+uDDN4FAPl3rtn6iOzxkcpFYhR+0+eNP1agQr/chVR2Uf+HUaJdAMeeHiiC8g4K0elq8EPXf8Nhe4wEh9cICBbsMaD4x/PuNyA7zf2WxzQd6ReZ+bmMgt2r8kU+zwlMZ68B+/SiBLg7kmbPjyzMTiDPKZEqQFM3qwZ5f/0T4ClJCwHBa+ydBfu+41tzUlqi0rrYs8PyEFpY8crxQPwLSgnNIo3pys44oapP/Xohwe+szlUBNKdd5gJHmPc8t0EauFA0v9ZTWNc3npr/BUBdNvY4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bfffeee-047f-43f5-d9d0-08d802a4e39d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:17:29.2588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CGGBIuIOe8zmXQ+Bn99IfdAKMztMndO+YjZgSlohKebRE8wAi1hpg8lxASmFkNen8sAb5/d9A+eGP6kWoNPNMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Restructure the eswitch ingress acl codes into eswitch directory
and different files:
. Acl ingress helper functions to acl_helper.c/h
. Acl ingress functions used in offloads mode to acl_ingress_ofld.c
. Acl ingress functions used in legacy mode to acl_ingress_lgy.c

This patch does not change any functionality.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   3 +-
 .../mellanox/mlx5/core/esw/acl/helper.c       |  18 +
 .../mellanox/mlx5/core/esw/acl/helper.h       |   4 +
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c | 279 +++++++++++++++
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c | 293 ++++++++++++++++
 .../mellanox/mlx5/core/esw/acl/lgcy.h         |   4 +
 .../mellanox/mlx5/core/esw/acl/ofld.h         |   4 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 322 +-----------------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   6 -
 .../mellanox/mlx5/core/eswitch_offloads.c     | 269 +--------------
 10 files changed, 619 insertions(+), 583 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index ad046b2ea4f9..3934dc258041 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -47,7 +47,8 @@ mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   += eswitch.o eswitch_offloads.o eswitch_offloads_termtbl.o \
 				      ecpf.o rdma.o
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   += esw/acl/helper.o \
-				      esw/acl/egress_lgcy.o esw/acl/egress_ofld.o
+				      esw/acl/egress_lgcy.o esw/acl/egress_ofld.o \
+				      esw/acl/ingress_lgcy.o esw/acl/ingress_ofld.o
 
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          += lib/vxlan.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
index 8b7996721a7c..22f4c1c28006 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
@@ -140,3 +140,21 @@ void esw_acl_egress_table_destroy(struct mlx5_vport *vport)
 	mlx5_destroy_flow_table(vport->egress.acl);
 	vport->egress.acl = NULL;
 }
+
+void esw_acl_ingress_table_destroy(struct mlx5_vport *vport)
+{
+	if (!vport->ingress.acl)
+		return;
+
+	mlx5_destroy_flow_table(vport->ingress.acl);
+	vport->ingress.acl = NULL;
+}
+
+void esw_acl_ingress_allow_rule_destroy(struct mlx5_vport *vport)
+{
+	if (!vport->ingress.allow_rule)
+		return;
+
+	mlx5_del_flow_rules(vport->ingress.allow_rule);
+	vport->ingress.allow_rule = NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
index 543372df6196..8dc4cab66a71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
@@ -19,4 +19,8 @@ void esw_acl_egress_vlan_destroy(struct mlx5_vport *vport);
 int esw_acl_egress_vlan_grp_create(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 void esw_acl_egress_vlan_grp_destroy(struct mlx5_vport *vport);
 
+/* Ingress acl helper functions */
+void esw_acl_ingress_table_destroy(struct mlx5_vport *vport);
+void esw_acl_ingress_allow_rule_destroy(struct mlx5_vport *vport);
+
 #endif /* __MLX5_ESWITCH_ACL_HELPER_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
new file mode 100644
index 000000000000..9bda4fe2eafa
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -0,0 +1,279 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Inc. All rights reserved. */
+
+#include "mlx5_core.h"
+#include "eswitch.h"
+#include "helper.h"
+#include "lgcy.h"
+
+static void esw_acl_ingress_lgcy_rules_destroy(struct mlx5_vport *vport)
+{
+	if (vport->ingress.legacy.drop_rule) {
+		mlx5_del_flow_rules(vport->ingress.legacy.drop_rule);
+		vport->ingress.legacy.drop_rule = NULL;
+	}
+	esw_acl_ingress_allow_rule_destroy(vport);
+}
+
+static int esw_acl_ingress_lgcy_groups_create(struct mlx5_eswitch *esw,
+					      struct mlx5_vport *vport)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_core_dev *dev = esw->dev;
+	struct mlx5_flow_group *g;
+	void *match_criteria;
+	u32 *flow_group_in;
+	int err;
+
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!flow_group_in)
+		return -ENOMEM;
+
+	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
+
+	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
+		 MLX5_MATCH_OUTER_HEADERS);
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_47_16);
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_15_0);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 0);
+
+	g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		esw_warn(dev, "vport[%d] ingress create untagged spoofchk flow group, err(%d)\n",
+			 vport->vport, err);
+		goto spoof_err;
+	}
+	vport->ingress.legacy.allow_untagged_spoofchk_grp = g;
+
+	memset(flow_group_in, 0, inlen);
+	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
+		 MLX5_MATCH_OUTER_HEADERS);
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 1);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 1);
+
+	g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		esw_warn(dev, "vport[%d] ingress create untagged flow group, err(%d)\n",
+			 vport->vport, err);
+		goto untagged_err;
+	}
+	vport->ingress.legacy.allow_untagged_only_grp = g;
+
+	memset(flow_group_in, 0, inlen);
+	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
+		 MLX5_MATCH_OUTER_HEADERS);
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_47_16);
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_15_0);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 2);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 2);
+
+	g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		esw_warn(dev, "vport[%d] ingress create spoofchk flow group, err(%d)\n",
+			 vport->vport, err);
+		goto allow_spoof_err;
+	}
+	vport->ingress.legacy.allow_spoofchk_only_grp = g;
+
+	memset(flow_group_in, 0, inlen);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 3);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 3);
+
+	g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		esw_warn(dev, "vport[%d] ingress create drop flow group, err(%d)\n",
+			 vport->vport, err);
+		goto drop_err;
+	}
+	vport->ingress.legacy.drop_grp = g;
+	kvfree(flow_group_in);
+	return 0;
+
+drop_err:
+	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_spoofchk_only_grp)) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_spoofchk_only_grp);
+		vport->ingress.legacy.allow_spoofchk_only_grp = NULL;
+	}
+allow_spoof_err:
+	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_untagged_only_grp)) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_only_grp);
+		vport->ingress.legacy.allow_untagged_only_grp = NULL;
+	}
+untagged_err:
+	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_untagged_spoofchk_grp)) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_spoofchk_grp);
+		vport->ingress.legacy.allow_untagged_spoofchk_grp = NULL;
+	}
+spoof_err:
+	kvfree(flow_group_in);
+	return err;
+}
+
+static void esw_acl_ingress_lgcy_groups_destroy(struct mlx5_vport *vport)
+{
+	if (vport->ingress.legacy.allow_spoofchk_only_grp) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_spoofchk_only_grp);
+		vport->ingress.legacy.allow_spoofchk_only_grp = NULL;
+	}
+	if (vport->ingress.legacy.allow_untagged_only_grp) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_only_grp);
+		vport->ingress.legacy.allow_untagged_only_grp = NULL;
+	}
+	if (vport->ingress.legacy.allow_untagged_spoofchk_grp) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_spoofchk_grp);
+		vport->ingress.legacy.allow_untagged_spoofchk_grp = NULL;
+	}
+	if (vport->ingress.legacy.drop_grp) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.drop_grp);
+		vport->ingress.legacy.drop_grp = NULL;
+	}
+}
+
+int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
+			       struct mlx5_vport *vport)
+{
+	struct mlx5_flow_destination drop_ctr_dst = {};
+	struct mlx5_flow_destination *dst = NULL;
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_spec *spec = NULL;
+	struct mlx5_fc *counter = NULL;
+	/* The ingress acl table contains 4 groups
+	 * (2 active rules at the same time -
+	 *      1 allow rule from one of the first 3 groups.
+	 *      1 drop rule from the last group):
+	 * 1)Allow untagged traffic with smac=original mac.
+	 * 2)Allow untagged traffic.
+	 * 3)Allow traffic with smac=original mac.
+	 * 4)Drop all other traffic.
+	 */
+	int table_size = 4;
+	int dest_num = 0;
+	int err = 0;
+	u8 *smac_v;
+
+	esw_acl_ingress_lgcy_rules_destroy(vport);
+
+	if (MLX5_CAP_ESW_INGRESS_ACL(esw->dev, flow_counter)) {
+		counter = mlx5_fc_create(esw->dev, false);
+		if (IS_ERR(counter))
+			esw_warn(esw->dev,
+				 "vport[%d] configure ingress drop rule counter failed\n",
+				 vport->vport);
+		vport->ingress.legacy.drop_counter = counter;
+	}
+
+	if (!vport->info.vlan && !vport->info.qos && !vport->info.spoofchk) {
+		esw_acl_ingress_lgcy_cleanup(esw, vport);
+		return 0;
+	}
+
+	if (!vport->ingress.acl) {
+		vport->ingress.acl = esw_acl_table_create(esw, vport->vport,
+							  MLX5_FLOW_NAMESPACE_ESW_INGRESS,
+							  table_size);
+		if (IS_ERR_OR_NULL(vport->ingress.acl)) {
+			err = PTR_ERR(vport->ingress.acl);
+			vport->ingress.acl = NULL;
+			return err;
+		}
+
+		err = esw_acl_ingress_lgcy_groups_create(esw, vport);
+		if (err)
+			goto out;
+	}
+
+	esw_debug(esw->dev,
+		  "vport[%d] configure ingress rules, vlan(%d) qos(%d)\n",
+		  vport->vport, vport->info.vlan, vport->info.qos);
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	if (vport->info.vlan || vport->info.qos)
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+				 outer_headers.cvlan_tag);
+
+	if (vport->info.spoofchk) {
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+				 outer_headers.smac_47_16);
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+				 outer_headers.smac_15_0);
+		smac_v = MLX5_ADDR_OF(fte_match_param,
+				      spec->match_value,
+				      outer_headers.smac_47_16);
+		ether_addr_copy(smac_v, vport->info.mac);
+	}
+
+	/* Create ingress allow rule */
+	memset(spec, 0, sizeof(*spec));
+	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+	vport->ingress.allow_rule = mlx5_add_flow_rules(vport->ingress.acl, spec,
+							&flow_act, NULL, 0);
+	if (IS_ERR(vport->ingress.allow_rule)) {
+		err = PTR_ERR(vport->ingress.allow_rule);
+		esw_warn(esw->dev,
+			 "vport[%d] configure ingress allow rule, err(%d)\n",
+			 vport->vport, err);
+		vport->ingress.allow_rule = NULL;
+		goto out;
+	}
+
+	memset(&flow_act, 0, sizeof(flow_act));
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
+	/* Attach drop flow counter */
+	if (counter) {
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+		drop_ctr_dst.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+		drop_ctr_dst.counter_id = mlx5_fc_id(counter);
+		dst = &drop_ctr_dst;
+		dest_num++;
+	}
+	vport->ingress.legacy.drop_rule =
+		mlx5_add_flow_rules(vport->ingress.acl, NULL,
+				    &flow_act, dst, dest_num);
+	if (IS_ERR(vport->ingress.legacy.drop_rule)) {
+		err = PTR_ERR(vport->ingress.legacy.drop_rule);
+		esw_warn(esw->dev,
+			 "vport[%d] configure ingress drop rule, err(%d)\n",
+			 vport->vport, err);
+		vport->ingress.legacy.drop_rule = NULL;
+		goto out;
+	}
+	kvfree(spec);
+	return 0;
+
+out:
+	esw_acl_ingress_lgcy_cleanup(esw, vport);
+	kvfree(spec);
+	return err;
+}
+
+void esw_acl_ingress_lgcy_cleanup(struct mlx5_eswitch *esw,
+				  struct mlx5_vport *vport)
+{
+	if (IS_ERR_OR_NULL(vport->ingress.acl))
+		goto clean_drop_counter;
+
+	esw_debug(esw->dev, "Destroy vport[%d] E-Switch ingress ACL\n", vport->vport);
+
+	esw_acl_ingress_lgcy_rules_destroy(vport);
+	esw_acl_ingress_lgcy_groups_destroy(vport);
+	esw_acl_ingress_table_destroy(vport);
+
+clean_drop_counter:
+	if (!IS_ERR_OR_NULL(vport->ingress.legacy.drop_counter)) {
+		mlx5_fc_destroy(esw->dev, vport->ingress.legacy.drop_counter);
+		vport->ingress.legacy.drop_counter = NULL;
+	}
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
new file mode 100644
index 000000000000..1bae549f3fa7
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
@@ -0,0 +1,293 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Inc. All rights reserved. */
+
+#include "mlx5_core.h"
+#include "eswitch.h"
+#include "helper.h"
+#include "ofld.h"
+
+static bool
+esw_acl_ingress_prio_tag_enabled(const struct mlx5_eswitch *esw,
+				 const struct mlx5_vport *vport)
+{
+	return (MLX5_CAP_GEN(esw->dev, prio_tag_required) &&
+		mlx5_eswitch_is_vf_vport(esw, vport->vport));
+}
+
+static int esw_acl_ingress_prio_tag_create(struct mlx5_eswitch *esw,
+					   struct mlx5_vport *vport)
+{
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_spec *spec;
+	int err = 0;
+
+	/* For prio tag mode, there is only 1 FTEs:
+	 * 1) Untagged packets - push prio tag VLAN and modify metadata if
+	 * required, allow
+	 * Unmatched traffic is allowed by default
+	 */
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	/* Untagged packets - push prio tag VLAN, allow */
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvlan_tag);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.cvlan_tag, 0);
+	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH |
+			  MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+	flow_act.vlan[0].ethtype = ETH_P_8021Q;
+	flow_act.vlan[0].vid = 0;
+	flow_act.vlan[0].prio = 0;
+
+	if (vport->ingress.offloads.modify_metadata_rule) {
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+		flow_act.modify_hdr = vport->ingress.offloads.modify_metadata;
+	}
+
+	vport->ingress.allow_rule = mlx5_add_flow_rules(vport->ingress.acl, spec,
+							&flow_act, NULL, 0);
+	if (IS_ERR(vport->ingress.allow_rule)) {
+		err = PTR_ERR(vport->ingress.allow_rule);
+		esw_warn(esw->dev,
+			 "vport[%d] configure ingress untagged allow rule, err(%d)\n",
+			 vport->vport, err);
+		vport->ingress.allow_rule = NULL;
+	}
+
+	kvfree(spec);
+	return err;
+}
+
+static int esw_acl_ingress_mod_metadata_create(struct mlx5_eswitch *esw,
+					       struct mlx5_vport *vport)
+{
+	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
+	struct mlx5_flow_act flow_act = {};
+	int err = 0;
+	u32 key;
+
+	key = mlx5_eswitch_get_vport_metadata_for_match(esw, vport->vport);
+	key >>= ESW_SOURCE_PORT_METADATA_OFFSET;
+
+	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
+	MLX5_SET(set_action_in, action, field,
+		 MLX5_ACTION_IN_FIELD_METADATA_REG_C_0);
+	MLX5_SET(set_action_in, action, data, key);
+	MLX5_SET(set_action_in, action, offset,
+		 ESW_SOURCE_PORT_METADATA_OFFSET);
+	MLX5_SET(set_action_in, action, length,
+		 ESW_SOURCE_PORT_METADATA_BITS);
+
+	vport->ingress.offloads.modify_metadata =
+		mlx5_modify_header_alloc(esw->dev, MLX5_FLOW_NAMESPACE_ESW_INGRESS,
+					 1, action);
+	if (IS_ERR(vport->ingress.offloads.modify_metadata)) {
+		err = PTR_ERR(vport->ingress.offloads.modify_metadata);
+		esw_warn(esw->dev,
+			 "failed to alloc modify header for vport %d ingress acl (%d)\n",
+			 vport->vport, err);
+		return err;
+	}
+
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_MOD_HDR | MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+	flow_act.modify_hdr = vport->ingress.offloads.modify_metadata;
+	vport->ingress.offloads.modify_metadata_rule =
+				mlx5_add_flow_rules(vport->ingress.acl,
+						    NULL, &flow_act, NULL, 0);
+	if (IS_ERR(vport->ingress.offloads.modify_metadata_rule)) {
+		err = PTR_ERR(vport->ingress.offloads.modify_metadata_rule);
+		esw_warn(esw->dev,
+			 "failed to add setting metadata rule for vport %d ingress acl, err(%d)\n",
+			 vport->vport, err);
+		mlx5_modify_header_dealloc(esw->dev, vport->ingress.offloads.modify_metadata);
+		vport->ingress.offloads.modify_metadata_rule = NULL;
+	}
+	return err;
+}
+
+static void esw_acl_ingress_mod_metadata_destroy(struct mlx5_eswitch *esw,
+						 struct mlx5_vport *vport)
+{
+	if (!vport->ingress.offloads.modify_metadata_rule)
+		return;
+
+	mlx5_del_flow_rules(vport->ingress.offloads.modify_metadata_rule);
+	mlx5_modify_header_dealloc(esw->dev, vport->ingress.offloads.modify_metadata);
+	vport->ingress.offloads.modify_metadata_rule = NULL;
+}
+
+static int esw_acl_ingress_ofld_rules_create(struct mlx5_eswitch *esw,
+					     struct mlx5_vport *vport)
+{
+	int err;
+
+	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
+		err = esw_acl_ingress_mod_metadata_create(esw, vport);
+		if (err) {
+			esw_warn(esw->dev,
+				 "vport(%d) create ingress modify metadata, err(%d)\n",
+				 vport->vport, err);
+			return err;
+		}
+	}
+
+	if (esw_acl_ingress_prio_tag_enabled(esw, vport)) {
+		err = esw_acl_ingress_prio_tag_create(esw, vport);
+		if (err) {
+			esw_warn(esw->dev,
+				 "vport(%d) create ingress prio tag rule, err(%d)\n",
+				 vport->vport, err);
+			goto prio_tag_err;
+		}
+	}
+
+	return 0;
+
+prio_tag_err:
+	esw_acl_ingress_mod_metadata_destroy(esw, vport);
+	return err;
+}
+
+static void esw_acl_ingress_ofld_rules_destroy(struct mlx5_eswitch *esw,
+					       struct mlx5_vport *vport)
+{
+	esw_acl_ingress_allow_rule_destroy(vport);
+	esw_acl_ingress_mod_metadata_destroy(esw, vport);
+}
+
+static int esw_acl_ingress_ofld_groups_create(struct mlx5_eswitch *esw,
+					      struct mlx5_vport *vport)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *g;
+	void *match_criteria;
+	u32 *flow_group_in;
+	u32 flow_index = 0;
+	int ret = 0;
+
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!flow_group_in)
+		return -ENOMEM;
+
+	if (esw_acl_ingress_prio_tag_enabled(esw, vport)) {
+		/* This group is to hold FTE to match untagged packets when prio_tag
+		 * is enabled.
+		 */
+		match_criteria = MLX5_ADDR_OF(create_flow_group_in,
+					      flow_group_in, match_criteria);
+		MLX5_SET(create_flow_group_in, flow_group_in,
+			 match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
+		MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
+		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, flow_index);
+		MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, flow_index);
+
+		g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
+		if (IS_ERR(g)) {
+			ret = PTR_ERR(g);
+			esw_warn(esw->dev, "vport[%d] ingress create untagged flow group, err(%d)\n",
+				 vport->vport, ret);
+			goto prio_tag_err;
+		}
+		vport->ingress.offloads.metadata_prio_tag_grp = g;
+		flow_index++;
+	}
+
+	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
+		/* This group holds an FTE with no match to add metadata for
+		 * tagged packets if prio-tag is enabled, or for all untagged
+		 * traffic in case prio-tag is disabled.
+		 */
+		memset(flow_group_in, 0, inlen);
+		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, flow_index);
+		MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, flow_index);
+
+		g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
+		if (IS_ERR(g)) {
+			ret = PTR_ERR(g);
+			esw_warn(esw->dev, "vport[%d] ingress create drop flow group, err(%d)\n",
+				 vport->vport, ret);
+			goto metadata_err;
+		}
+		vport->ingress.offloads.metadata_allmatch_grp = g;
+	}
+
+	kvfree(flow_group_in);
+	return 0;
+
+metadata_err:
+	if (!IS_ERR_OR_NULL(vport->ingress.offloads.metadata_prio_tag_grp)) {
+		mlx5_destroy_flow_group(vport->ingress.offloads.metadata_prio_tag_grp);
+		vport->ingress.offloads.metadata_prio_tag_grp = NULL;
+	}
+prio_tag_err:
+	kvfree(flow_group_in);
+	return ret;
+}
+
+static void esw_acl_ingress_ofld_groups_destroy(struct mlx5_vport *vport)
+{
+	if (vport->ingress.offloads.metadata_allmatch_grp) {
+		mlx5_destroy_flow_group(vport->ingress.offloads.metadata_allmatch_grp);
+		vport->ingress.offloads.metadata_allmatch_grp = NULL;
+	}
+
+	if (vport->ingress.offloads.metadata_prio_tag_grp) {
+		mlx5_destroy_flow_group(vport->ingress.offloads.metadata_prio_tag_grp);
+		vport->ingress.offloads.metadata_prio_tag_grp = NULL;
+	}
+}
+
+int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw,
+			       struct mlx5_vport *vport)
+{
+	int num_ftes = 0;
+	int err;
+
+	if (!mlx5_eswitch_vport_match_metadata_enabled(esw) &&
+	    !esw_acl_ingress_prio_tag_enabled(esw, vport))
+		return 0;
+
+	esw_acl_ingress_allow_rule_destroy(vport);
+
+	if (mlx5_eswitch_vport_match_metadata_enabled(esw))
+		num_ftes++;
+	if (esw_acl_ingress_prio_tag_enabled(esw, vport))
+		num_ftes++;
+
+	vport->ingress.acl = esw_acl_table_create(esw, vport->vport,
+						  MLX5_FLOW_NAMESPACE_ESW_INGRESS,
+						  num_ftes);
+	if (IS_ERR_OR_NULL(vport->ingress.acl)) {
+		err = PTR_ERR(vport->ingress.acl);
+		vport->ingress.acl = NULL;
+		return err;
+	}
+
+	err = esw_acl_ingress_ofld_groups_create(esw, vport);
+	if (err)
+		goto group_err;
+
+	esw_debug(esw->dev,
+		  "vport[%d] configure ingress rules\n", vport->vport);
+
+	err = esw_acl_ingress_ofld_rules_create(esw, vport);
+	if (err)
+		goto rules_err;
+
+	return 0;
+
+rules_err:
+	esw_acl_ingress_ofld_groups_destroy(vport);
+group_err:
+	esw_acl_ingress_table_destroy(vport);
+	return err;
+}
+
+void esw_acl_ingress_ofld_cleanup(struct mlx5_eswitch *esw,
+				  struct mlx5_vport *vport)
+{
+	esw_acl_ingress_ofld_rules_destroy(esw, vport);
+	esw_acl_ingress_ofld_groups_destroy(vport);
+	esw_acl_ingress_table_destroy(vport);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
index 6b05a3af4462..44c152da3d83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
@@ -10,4 +10,8 @@
 int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 void esw_acl_egress_lgcy_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 
+/* Eswitch acl ingress external APIs */
+int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+void esw_acl_ingress_lgcy_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+
 #endif /* __MLX5_ESWITCH_ACL_LGCY_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
index fc912b254226..9e5e0fac29ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
@@ -10,4 +10,8 @@
 int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 void esw_acl_egress_ofld_cleanup(struct mlx5_vport *vport);
 
+/* Eswitch acl ingress external APIs */
+int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+void esw_acl_ingress_ofld_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+
 #endif /* __MLX5_ESWITCH_ACL_OFLD_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index ae74486b9c9e..20ab13ff2303 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -937,301 +937,6 @@ static void esw_vport_change_handler(struct work_struct *work)
 	mutex_unlock(&esw->state_lock);
 }
 
-static int
-esw_vport_create_legacy_ingress_acl_groups(struct mlx5_eswitch *esw,
-					   struct mlx5_vport *vport)
-{
-	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	struct mlx5_core_dev *dev = esw->dev;
-	struct mlx5_flow_group *g;
-	void *match_criteria;
-	u32 *flow_group_in;
-	int err;
-
-	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
-	if (!flow_group_in)
-		return -ENOMEM;
-
-	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
-
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_47_16);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_15_0);
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 0);
-
-	g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
-	if (IS_ERR(g)) {
-		err = PTR_ERR(g);
-		esw_warn(dev, "vport[%d] ingress create untagged spoofchk flow group, err(%d)\n",
-			 vport->vport, err);
-		goto spoof_err;
-	}
-	vport->ingress.legacy.allow_untagged_spoofchk_grp = g;
-
-	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 1);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 1);
-
-	g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
-	if (IS_ERR(g)) {
-		err = PTR_ERR(g);
-		esw_warn(dev, "vport[%d] ingress create untagged flow group, err(%d)\n",
-			 vport->vport, err);
-		goto untagged_err;
-	}
-	vport->ingress.legacy.allow_untagged_only_grp = g;
-
-	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_47_16);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_15_0);
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 2);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 2);
-
-	g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
-	if (IS_ERR(g)) {
-		err = PTR_ERR(g);
-		esw_warn(dev, "vport[%d] ingress create spoofchk flow group, err(%d)\n",
-			 vport->vport, err);
-		goto allow_spoof_err;
-	}
-	vport->ingress.legacy.allow_spoofchk_only_grp = g;
-
-	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 3);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 3);
-
-	g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
-	if (IS_ERR(g)) {
-		err = PTR_ERR(g);
-		esw_warn(dev, "vport[%d] ingress create drop flow group, err(%d)\n",
-			 vport->vport, err);
-		goto drop_err;
-	}
-	vport->ingress.legacy.drop_grp = g;
-	kvfree(flow_group_in);
-	return 0;
-
-drop_err:
-	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_spoofchk_only_grp)) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_spoofchk_only_grp);
-		vport->ingress.legacy.allow_spoofchk_only_grp = NULL;
-	}
-allow_spoof_err:
-	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_untagged_only_grp)) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_only_grp);
-		vport->ingress.legacy.allow_untagged_only_grp = NULL;
-	}
-untagged_err:
-	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_untagged_spoofchk_grp)) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_spoofchk_grp);
-		vport->ingress.legacy.allow_untagged_spoofchk_grp = NULL;
-	}
-spoof_err:
-	kvfree(flow_group_in);
-	return err;
-}
-
-int esw_vport_create_ingress_acl_table(struct mlx5_eswitch *esw,
-				       struct mlx5_vport *vport, int table_size)
-{
-	struct mlx5_core_dev *dev = esw->dev;
-	struct mlx5_flow_namespace *root_ns;
-	struct mlx5_flow_table *acl;
-	int vport_index;
-	int err;
-
-	if (!MLX5_CAP_ESW_INGRESS_ACL(dev, ft_support))
-		return -EOPNOTSUPP;
-
-	esw_debug(dev, "Create vport[%d] ingress ACL log_max_size(%d)\n",
-		  vport->vport, MLX5_CAP_ESW_INGRESS_ACL(dev, log_max_ft_size));
-
-	vport_index = mlx5_eswitch_vport_num_to_index(esw, vport->vport);
-	root_ns = mlx5_get_flow_vport_acl_namespace(dev, MLX5_FLOW_NAMESPACE_ESW_INGRESS,
-						    vport_index);
-	if (!root_ns) {
-		esw_warn(dev, "Failed to get E-Switch ingress flow namespace for vport (%d)\n",
-			 vport->vport);
-		return -EOPNOTSUPP;
-	}
-
-	acl = mlx5_create_vport_flow_table(root_ns, 0, table_size, 0, vport->vport);
-	if (IS_ERR(acl)) {
-		err = PTR_ERR(acl);
-		esw_warn(dev, "vport[%d] ingress create flow Table, err(%d)\n",
-			 vport->vport, err);
-		return err;
-	}
-	vport->ingress.acl = acl;
-	return 0;
-}
-
-void esw_vport_destroy_ingress_acl_table(struct mlx5_vport *vport)
-{
-	if (!vport->ingress.acl)
-		return;
-
-	mlx5_destroy_flow_table(vport->ingress.acl);
-	vport->ingress.acl = NULL;
-}
-
-void esw_vport_cleanup_ingress_rules(struct mlx5_eswitch *esw,
-				     struct mlx5_vport *vport)
-{
-	if (vport->ingress.legacy.drop_rule) {
-		mlx5_del_flow_rules(vport->ingress.legacy.drop_rule);
-		vport->ingress.legacy.drop_rule = NULL;
-	}
-
-	if (vport->ingress.allow_rule) {
-		mlx5_del_flow_rules(vport->ingress.allow_rule);
-		vport->ingress.allow_rule = NULL;
-	}
-}
-
-static void esw_vport_disable_legacy_ingress_acl(struct mlx5_eswitch *esw,
-						 struct mlx5_vport *vport)
-{
-	if (!vport->ingress.acl)
-		return;
-
-	esw_debug(esw->dev, "Destroy vport[%d] E-Switch ingress ACL\n", vport->vport);
-
-	esw_vport_cleanup_ingress_rules(esw, vport);
-	if (vport->ingress.legacy.allow_spoofchk_only_grp) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_spoofchk_only_grp);
-		vport->ingress.legacy.allow_spoofchk_only_grp = NULL;
-	}
-	if (vport->ingress.legacy.allow_untagged_only_grp) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_only_grp);
-		vport->ingress.legacy.allow_untagged_only_grp = NULL;
-	}
-	if (vport->ingress.legacy.allow_untagged_spoofchk_grp) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_spoofchk_grp);
-		vport->ingress.legacy.allow_untagged_spoofchk_grp = NULL;
-	}
-	if (vport->ingress.legacy.drop_grp) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.drop_grp);
-		vport->ingress.legacy.drop_grp = NULL;
-	}
-	esw_vport_destroy_ingress_acl_table(vport);
-}
-
-static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
-				    struct mlx5_vport *vport)
-{
-	struct mlx5_fc *counter = vport->ingress.legacy.drop_counter;
-	struct mlx5_flow_destination drop_ctr_dst = {0};
-	struct mlx5_flow_destination *dst = NULL;
-	struct mlx5_flow_act flow_act = {0};
-	struct mlx5_flow_spec *spec = NULL;
-	int dest_num = 0;
-	int err = 0;
-	u8 *smac_v;
-
-	/* The ingress acl table contains 4 groups
-	 * (2 active rules at the same time -
-	 *      1 allow rule from one of the first 3 groups.
-	 *      1 drop rule from the last group):
-	 * 1)Allow untagged traffic with smac=original mac.
-	 * 2)Allow untagged traffic.
-	 * 3)Allow traffic with smac=original mac.
-	 * 4)Drop all other traffic.
-	 */
-	int table_size = 4;
-
-	esw_vport_cleanup_ingress_rules(esw, vport);
-
-	if (!vport->info.vlan && !vport->info.qos && !vport->info.spoofchk) {
-		esw_vport_disable_legacy_ingress_acl(esw, vport);
-		return 0;
-	}
-
-	if (!vport->ingress.acl) {
-		err = esw_vport_create_ingress_acl_table(esw, vport, table_size);
-		if (err) {
-			esw_warn(esw->dev,
-				 "vport[%d] enable ingress acl err (%d)\n",
-				 err, vport->vport);
-			return err;
-		}
-
-		err = esw_vport_create_legacy_ingress_acl_groups(esw, vport);
-		if (err)
-			goto out;
-	}
-
-	esw_debug(esw->dev,
-		  "vport[%d] configure ingress rules, vlan(%d) qos(%d)\n",
-		  vport->vport, vport->info.vlan, vport->info.qos);
-
-	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
-	if (!spec) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	if (vport->info.vlan || vport->info.qos)
-		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvlan_tag);
-
-	if (vport->info.spoofchk) {
-		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.smac_47_16);
-		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.smac_15_0);
-		smac_v = MLX5_ADDR_OF(fte_match_param,
-				      spec->match_value,
-				      outer_headers.smac_47_16);
-		ether_addr_copy(smac_v, vport->info.mac);
-	}
-
-	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
-	vport->ingress.allow_rule =
-		mlx5_add_flow_rules(vport->ingress.acl, spec,
-				    &flow_act, NULL, 0);
-	if (IS_ERR(vport->ingress.allow_rule)) {
-		err = PTR_ERR(vport->ingress.allow_rule);
-		esw_warn(esw->dev,
-			 "vport[%d] configure ingress allow rule, err(%d)\n",
-			 vport->vport, err);
-		vport->ingress.allow_rule = NULL;
-		goto out;
-	}
-
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
-
-	/* Attach drop flow counter */
-	if (counter) {
-		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
-		drop_ctr_dst.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
-		drop_ctr_dst.counter_id = mlx5_fc_id(counter);
-		dst = &drop_ctr_dst;
-		dest_num++;
-	}
-	vport->ingress.legacy.drop_rule =
-		mlx5_add_flow_rules(vport->ingress.acl, NULL,
-				    &flow_act, dst, dest_num);
-	if (IS_ERR(vport->ingress.legacy.drop_rule)) {
-		err = PTR_ERR(vport->ingress.legacy.drop_rule);
-		esw_warn(esw->dev,
-			 "vport[%d] configure ingress drop rule, err(%d)\n",
-			 vport->vport, err);
-		vport->ingress.legacy.drop_rule = NULL;
-		goto out;
-	}
-	kvfree(spec);
-	return 0;
-
-out:
-	esw_vport_disable_legacy_ingress_acl(esw, vport);
-	kvfree(spec);
-	return err;
-}
-
 static bool element_type_supported(struct mlx5_eswitch *esw, int type)
 {
 	const struct mlx5_core_dev *dev = esw->dev;
@@ -1443,17 +1148,7 @@ static int esw_vport_create_legacy_acl_tables(struct mlx5_eswitch *esw,
 	if (mlx5_esw_is_manager_vport(esw, vport->vport))
 		return 0;
 
-	if (MLX5_CAP_ESW_INGRESS_ACL(esw->dev, flow_counter)) {
-		vport->ingress.legacy.drop_counter = mlx5_fc_create(esw->dev, false);
-		if (IS_ERR(vport->ingress.legacy.drop_counter)) {
-			esw_warn(esw->dev,
-				 "vport[%d] configure ingress drop rule counter failed\n",
-				 vport->vport);
-			vport->ingress.legacy.drop_counter = NULL;
-		}
-	}
-
-	ret = esw_vport_ingress_config(esw, vport);
+	ret = esw_acl_ingress_lgcy_setup(esw, vport);
 	if (ret)
 		goto ingress_err;
 
@@ -1464,10 +1159,8 @@ static int esw_vport_create_legacy_acl_tables(struct mlx5_eswitch *esw,
 	return 0;
 
 egress_err:
-	esw_vport_disable_legacy_ingress_acl(esw, vport);
+	esw_acl_ingress_lgcy_cleanup(esw, vport);
 ingress_err:
-	mlx5_fc_destroy(esw->dev, vport->ingress.legacy.drop_counter);
-	vport->ingress.legacy.drop_counter = NULL;
 	return ret;
 }
 
@@ -1488,10 +1181,7 @@ static void esw_vport_destroy_legacy_acl_tables(struct mlx5_eswitch *esw,
 		return;
 
 	esw_acl_egress_lgcy_cleanup(esw, vport);
-
-	esw_vport_disable_legacy_ingress_acl(esw, vport);
-	mlx5_fc_destroy(esw->dev, vport->ingress.legacy.drop_counter);
-	vport->ingress.legacy.drop_counter = NULL;
+	esw_acl_ingress_lgcy_cleanup(esw, vport);
 }
 
 static void esw_vport_cleanup_acl(struct mlx5_eswitch *esw,
@@ -2123,7 +1813,7 @@ int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
 	ether_addr_copy(evport->info.mac, mac);
 	evport->info.node_guid = node_guid;
 	if (evport->enabled && esw->mode == MLX5_ESWITCH_LEGACY)
-		err = esw_vport_ingress_config(esw, evport);
+		err = esw_acl_ingress_lgcy_setup(esw, evport);
 
 unlock:
 	mutex_unlock(&esw->state_lock);
@@ -2205,7 +1895,7 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 	evport->info.vlan = vlan;
 	evport->info.qos = qos;
 	if (evport->enabled && esw->mode == MLX5_ESWITCH_LEGACY) {
-		err = esw_vport_ingress_config(esw, evport);
+		err = esw_acl_ingress_lgcy_setup(esw, evport);
 		if (err)
 			return err;
 		err = esw_acl_egress_lgcy_setup(esw, evport);
@@ -2250,7 +1940,7 @@ int mlx5_eswitch_set_vport_spoofchk(struct mlx5_eswitch *esw,
 			       "Spoofchk in set while MAC is invalid, vport(%d)\n",
 			       evport->vport);
 	if (evport->enabled && esw->mode == MLX5_ESWITCH_LEGACY)
-		err = esw_vport_ingress_config(esw, evport);
+		err = esw_acl_ingress_lgcy_setup(esw, evport);
 	if (err)
 		evport->info.spoofchk = pschk;
 	mutex_unlock(&esw->state_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 490410401631..ca7b7961c295 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -285,12 +285,6 @@ void esw_offloads_disable(struct mlx5_eswitch *esw);
 int esw_offloads_enable(struct mlx5_eswitch *esw);
 void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw);
 int esw_offloads_init_reps(struct mlx5_eswitch *esw);
-void esw_vport_cleanup_ingress_rules(struct mlx5_eswitch *esw,
-				     struct mlx5_vport *vport);
-int esw_vport_create_ingress_acl_table(struct mlx5_eswitch *esw,
-				       struct mlx5_vport *vport,
-				       int table_size);
-void esw_vport_destroy_ingress_acl_table(struct mlx5_vport *vport);
 
 int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
 			       u32 rate_mbps);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 0b00b30187ce..11bc9cc1d5f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -235,13 +235,6 @@ static struct mlx5_eswitch_rep *mlx5_eswitch_get_rep(struct mlx5_eswitch *esw,
 	return &esw->offloads.vport_reps[idx];
 }
 
-static bool
-esw_check_ingress_prio_tag_enabled(const struct mlx5_eswitch *esw,
-				   const struct mlx5_vport *vport)
-{
-	return (MLX5_CAP_GEN(esw->dev, prio_tag_required) &&
-		mlx5_eswitch_is_vf_vport(esw, vport->vport));
-}
 
 static void
 mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
@@ -1852,248 +1845,6 @@ static void esw_offloads_devcom_cleanup(struct mlx5_eswitch *esw)
 	mlx5_devcom_unregister_component(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 }
 
-static int esw_vport_ingress_prio_tag_config(struct mlx5_eswitch *esw,
-					     struct mlx5_vport *vport)
-{
-	struct mlx5_flow_act flow_act = {0};
-	struct mlx5_flow_spec *spec;
-	int err = 0;
-
-	/* For prio tag mode, there is only 1 FTEs:
-	 * 1) Untagged packets - push prio tag VLAN and modify metadata if
-	 * required, allow
-	 * Unmatched traffic is allowed by default
-	 */
-	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
-	if (!spec)
-		return -ENOMEM;
-
-	/* Untagged packets - push prio tag VLAN, allow */
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvlan_tag);
-	MLX5_SET(fte_match_param, spec->match_value, outer_headers.cvlan_tag, 0);
-	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH |
-			  MLX5_FLOW_CONTEXT_ACTION_ALLOW;
-	flow_act.vlan[0].ethtype = ETH_P_8021Q;
-	flow_act.vlan[0].vid = 0;
-	flow_act.vlan[0].prio = 0;
-
-	if (vport->ingress.offloads.modify_metadata_rule) {
-		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-		flow_act.modify_hdr = vport->ingress.offloads.modify_metadata;
-	}
-
-	vport->ingress.allow_rule =
-		mlx5_add_flow_rules(vport->ingress.acl, spec,
-				    &flow_act, NULL, 0);
-	if (IS_ERR(vport->ingress.allow_rule)) {
-		err = PTR_ERR(vport->ingress.allow_rule);
-		esw_warn(esw->dev,
-			 "vport[%d] configure ingress untagged allow rule, err(%d)\n",
-			 vport->vport, err);
-		vport->ingress.allow_rule = NULL;
-	}
-
-	kvfree(spec);
-	return err;
-}
-
-static int esw_vport_add_ingress_acl_modify_metadata(struct mlx5_eswitch *esw,
-						     struct mlx5_vport *vport)
-{
-	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
-	struct mlx5_flow_act flow_act = {};
-	int err = 0;
-	u32 key;
-
-	key = mlx5_eswitch_get_vport_metadata_for_match(esw, vport->vport);
-	key >>= ESW_SOURCE_PORT_METADATA_OFFSET;
-
-	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
-	MLX5_SET(set_action_in, action, field,
-		 MLX5_ACTION_IN_FIELD_METADATA_REG_C_0);
-	MLX5_SET(set_action_in, action, data, key);
-	MLX5_SET(set_action_in, action, offset,
-		 ESW_SOURCE_PORT_METADATA_OFFSET);
-	MLX5_SET(set_action_in, action, length,
-		 ESW_SOURCE_PORT_METADATA_BITS);
-
-	vport->ingress.offloads.modify_metadata =
-		mlx5_modify_header_alloc(esw->dev, MLX5_FLOW_NAMESPACE_ESW_INGRESS,
-					 1, action);
-	if (IS_ERR(vport->ingress.offloads.modify_metadata)) {
-		err = PTR_ERR(vport->ingress.offloads.modify_metadata);
-		esw_warn(esw->dev,
-			 "failed to alloc modify header for vport %d ingress acl (%d)\n",
-			 vport->vport, err);
-		return err;
-	}
-
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_MOD_HDR | MLX5_FLOW_CONTEXT_ACTION_ALLOW;
-	flow_act.modify_hdr = vport->ingress.offloads.modify_metadata;
-	vport->ingress.offloads.modify_metadata_rule =
-				mlx5_add_flow_rules(vport->ingress.acl,
-						    NULL, &flow_act, NULL, 0);
-	if (IS_ERR(vport->ingress.offloads.modify_metadata_rule)) {
-		err = PTR_ERR(vport->ingress.offloads.modify_metadata_rule);
-		esw_warn(esw->dev,
-			 "failed to add setting metadata rule for vport %d ingress acl, err(%d)\n",
-			 vport->vport, err);
-		mlx5_modify_header_dealloc(esw->dev, vport->ingress.offloads.modify_metadata);
-		vport->ingress.offloads.modify_metadata_rule = NULL;
-	}
-	return err;
-}
-
-static void esw_vport_del_ingress_acl_modify_metadata(struct mlx5_eswitch *esw,
-						      struct mlx5_vport *vport)
-{
-	if (vport->ingress.offloads.modify_metadata_rule) {
-		mlx5_del_flow_rules(vport->ingress.offloads.modify_metadata_rule);
-		mlx5_modify_header_dealloc(esw->dev, vport->ingress.offloads.modify_metadata);
-
-		vport->ingress.offloads.modify_metadata_rule = NULL;
-	}
-}
-
-static int esw_vport_create_ingress_acl_group(struct mlx5_eswitch *esw,
-					      struct mlx5_vport *vport)
-{
-	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	struct mlx5_flow_group *g;
-	void *match_criteria;
-	u32 *flow_group_in;
-	u32 flow_index = 0;
-	int ret = 0;
-
-	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
-	if (!flow_group_in)
-		return -ENOMEM;
-
-	if (esw_check_ingress_prio_tag_enabled(esw, vport)) {
-		/* This group is to hold FTE to match untagged packets when prio_tag
-		 * is enabled.
-		 */
-		memset(flow_group_in, 0, inlen);
-
-		match_criteria = MLX5_ADDR_OF(create_flow_group_in,
-					      flow_group_in, match_criteria);
-		MLX5_SET(create_flow_group_in, flow_group_in,
-			 match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
-		MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
-		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, flow_index);
-		MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, flow_index);
-
-		g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
-		if (IS_ERR(g)) {
-			ret = PTR_ERR(g);
-			esw_warn(esw->dev, "vport[%d] ingress create untagged flow group, err(%d)\n",
-				 vport->vport, ret);
-			goto prio_tag_err;
-		}
-		vport->ingress.offloads.metadata_prio_tag_grp = g;
-		flow_index++;
-	}
-
-	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
-		/* This group holds an FTE with no matches for add metadata for
-		 * tagged packets, if prio-tag is enabled (as a fallthrough),
-		 * or all traffic in case prio-tag is disabled.
-		 */
-		memset(flow_group_in, 0, inlen);
-		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, flow_index);
-		MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, flow_index);
-
-		g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
-		if (IS_ERR(g)) {
-			ret = PTR_ERR(g);
-			esw_warn(esw->dev, "vport[%d] ingress create drop flow group, err(%d)\n",
-				 vport->vport, ret);
-			goto metadata_err;
-		}
-		vport->ingress.offloads.metadata_allmatch_grp = g;
-	}
-
-	kvfree(flow_group_in);
-	return 0;
-
-metadata_err:
-	if (!IS_ERR_OR_NULL(vport->ingress.offloads.metadata_prio_tag_grp)) {
-		mlx5_destroy_flow_group(vport->ingress.offloads.metadata_prio_tag_grp);
-		vport->ingress.offloads.metadata_prio_tag_grp = NULL;
-	}
-prio_tag_err:
-	kvfree(flow_group_in);
-	return ret;
-}
-
-static void esw_vport_destroy_ingress_acl_group(struct mlx5_vport *vport)
-{
-	if (vport->ingress.offloads.metadata_allmatch_grp) {
-		mlx5_destroy_flow_group(vport->ingress.offloads.metadata_allmatch_grp);
-		vport->ingress.offloads.metadata_allmatch_grp = NULL;
-	}
-
-	if (vport->ingress.offloads.metadata_prio_tag_grp) {
-		mlx5_destroy_flow_group(vport->ingress.offloads.metadata_prio_tag_grp);
-		vport->ingress.offloads.metadata_prio_tag_grp = NULL;
-	}
-}
-
-static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
-				    struct mlx5_vport *vport)
-{
-	int num_ftes = 0;
-	int err;
-
-	if (!mlx5_eswitch_vport_match_metadata_enabled(esw) &&
-	    !esw_check_ingress_prio_tag_enabled(esw, vport))
-		return 0;
-
-	esw_vport_cleanup_ingress_rules(esw, vport);
-
-	if (mlx5_eswitch_vport_match_metadata_enabled(esw))
-		num_ftes++;
-	if (esw_check_ingress_prio_tag_enabled(esw, vport))
-		num_ftes++;
-
-	err = esw_vport_create_ingress_acl_table(esw, vport, num_ftes);
-	if (err) {
-		esw_warn(esw->dev,
-			 "failed to enable ingress acl (%d) on vport[%d]\n",
-			 err, vport->vport);
-		return err;
-	}
-
-	err = esw_vport_create_ingress_acl_group(esw, vport);
-	if (err)
-		goto group_err;
-
-	esw_debug(esw->dev,
-		  "vport[%d] configure ingress rules\n", vport->vport);
-
-	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
-		err = esw_vport_add_ingress_acl_modify_metadata(esw, vport);
-		if (err)
-			goto metadata_err;
-	}
-
-	if (esw_check_ingress_prio_tag_enabled(esw, vport)) {
-		err = esw_vport_ingress_prio_tag_config(esw, vport);
-		if (err)
-			goto prio_tag_err;
-	}
-	return 0;
-
-prio_tag_err:
-	esw_vport_del_ingress_acl_modify_metadata(esw, vport);
-metadata_err:
-	esw_vport_destroy_ingress_acl_group(vport);
-group_err:
-	esw_vport_destroy_ingress_acl_table(vport);
-	return err;
-}
-
 static bool
 esw_check_vport_match_metadata_supported(const struct mlx5_eswitch *esw)
 {
@@ -2132,19 +1883,20 @@ esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
 {
 	int err;
 
-	err = esw_vport_ingress_config(esw, vport);
+	err = esw_acl_ingress_ofld_setup(esw, vport);
 	if (err)
 		return err;
 
 	if (mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
 		err = esw_acl_egress_ofld_setup(esw, vport);
-		if (err) {
-			esw_vport_cleanup_ingress_rules(esw, vport);
-			esw_vport_del_ingress_acl_modify_metadata(esw, vport);
-			esw_vport_destroy_ingress_acl_group(vport);
-			esw_vport_destroy_ingress_acl_table(vport);
-		}
+		if (err)
+			goto egress_err;
 	}
+
+	return 0;
+
+egress_err:
+	esw_acl_ingress_ofld_cleanup(esw, vport);
 	return err;
 }
 
@@ -2153,10 +1905,7 @@ esw_vport_destroy_offloads_acl_tables(struct mlx5_eswitch *esw,
 				      struct mlx5_vport *vport)
 {
 	esw_acl_egress_ofld_cleanup(vport);
-	esw_vport_cleanup_ingress_rules(esw, vport);
-	esw_vport_del_ingress_acl_modify_metadata(esw, vport);
-	esw_vport_destroy_ingress_acl_group(vport);
-	esw_vport_destroy_ingress_acl_table(vport);
+	esw_acl_ingress_ofld_cleanup(esw, vport);
 }
 
 static int esw_create_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
-- 
2.26.2

