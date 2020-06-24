Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6D8206B5D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 06:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388616AbgFXEr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 00:47:28 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:19185
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728732AbgFXErZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 00:47:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXBfC0b5Mje4tzuClFEO/CTGh7GNCo+tfoFfq1dFmmadfF0L2p9F+i1vuj+tyrYIN58D/Euyosqv6/jyKpofONU8OT0G6kFx8DkcmWTR2pIubUukhrghXUr7vqwpLY8rBM8Sss54Mfc28VN5bINHfQ/UcsSOnKA9rRiJ6ZEqglTZ6OoumH/7mS2cmwpW+kYDzokmXvXFAgNc0vRXrzSaaNtZNCfM/kgI9wrP6injSCG24jskRqK0FsuuhbbSy+C5wbb/HHeoR2U87PEkYCPtm1/vhQXmGxNLJxFqUJpon1zY70LN/JOTGLmFaGlSdJAY22fEUDk9VIvXmGuqxJVKoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvKzaRmOsLxjnvu6DyvBKkNP2RRBc1o5N8JkUbB/So8=;
 b=cCRa1MOfURoq2LePqyitHoJQBgvwcKzfoa2F6fQ52jUoIEC9yA82d1ghbYY/wgP8j/Gg1T05cD5vL6ty8hLKSH/KW89q+NfTu1PsS6NhpXZgkotjaiOh+Tsl10kyW8oBeLpFP01CfOts5H/J6svEvvxM288kBXKhnthFuiqA9HgwrhAzuBYXVACTpeeN9vyVe7MnyX/ZlPdSeaNCRsMVln8jbQH+VqnyVkSY5GmHj2vKVLkM882YuW+mP6DZ1FVklPonzeQ1dfyidj3W5wSfhTBrE4BpstFgrlUoA5ooZ5P8SVd+yQzx/RNI73l3wS2vdOXgg0Ia0MEFKpQ9fGZYJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvKzaRmOsLxjnvu6DyvBKkNP2RRBc1o5N8JkUbB/So8=;
 b=RUBJJntltVLxDELbq4XGv2QN0jw6n5rh2YyHiJ9YFo2ZQ84Xr1H68mpbibwuHNKEHDe4zoAFWHJA3Uscd89IXjxL64UEYtAebNV/bkgnbbLbhDh0fymbg/wWd7qmaDgxizedbIj15DGNF2e3e8CjKkazp8Qr2HX2nIo+DRVzKhg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5135.eurprd05.prod.outlook.com (2603:10a6:803:af::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Wed, 24 Jun
 2020 04:47:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 04:47:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 1/9] net/mlx5: Avoid eswitch header inclusion in fs core layer
Date:   Tue, 23 Jun 2020 21:46:07 -0700
Message-Id: <20200624044615.64553-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624044615.64553-1-saeedm@mellanox.com>
References: <20200624044615.64553-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:a03:54::28) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (216.228.112.22) by BYAPR02CA0051.namprd02.prod.outlook.com (2603:10b6:a03:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 24 Jun 2020 04:47:17 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [216.228.112.22]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bc2eb804-26c1-493b-e9e6-08d817f9acaf
X-MS-TrafficTypeDiagnostic: VI1PR05MB5135:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB513569C6ACEBD68BF27723C8BE950@VI1PR05MB5135.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dEHa8rmNo5YGWHJh7KMSJ7IF46kfj9ONIUmeoGQrYflCsbl4qldC91SLO69PKjtivzsKpjK7RE3lrssIQOUfqSH6o/1NnK9cJQXqXYv13o7gnNb1XXYtDCaCR/MxcRN9ruMzBxZGD1kWDamk3sYwp+Tesfpr66fWS+R1NCTRFyKtgt9dzGkZG6pr1CY9QkMMZyYHf8O6obI66TeJDXjuN4oip0LNFr3j8PIleQwbJNWMV6siJ/lU+v17a7EvwnCfmB+FcpU/I6vdJTWtAcHjnk8RF8GsMnwY6TAgKVcMFc9jv75VT6nxEU5vMU78Hp+Gv6M1kWB7iRlxqnvmqbNwRiQclq81iyGveCjCmD13pDuY0ZFF2wkHFXqA2GmSE8uu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39850400004)(376002)(366004)(396003)(136003)(107886003)(52116002)(86362001)(8676002)(8936002)(478600001)(26005)(83380400001)(5660300002)(6512007)(2906002)(54906003)(4326008)(956004)(186003)(6666004)(16526019)(316002)(2616005)(6506007)(66556008)(66476007)(6486002)(1076003)(66946007)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pjcJGi9l/FOL7IvNtuiUMiaB9IwYS9qWe8A3a77Cx7HpDaQG3Ct1pe5pMpP5Lch6SJZt284XzrDAv7IIhe2+Q2YYWlZKqtBPHQAiFBd1HlmZW6lI2iUlA8KKwxzq+WauaAMSJUV0BD/FyUsfC6tlDdBCjI81TRM7tETvBHPr7eXounmimFrzMI1UwQWpc9DcG9eMmaLyIYchvU0vwffhW+et05+8oaq1MTKMcWgnipm3DvX6Y585+AwTnVpFdPxUNObiVePGmOwcp3rF3ItwyeEqzzM0YR76UqGTMVO4k7PzIIT2k7aIDcHbYSuZJFqavR1eeXQwmGAc0ZGI2WY1dTUUOWlyJGA8WbZprM3FNLEZ/V+imgq8V9kQiNv/2AheEWh8nNQu/4PtZLT33UtzYXGEagOvxb3HRNRV7/VwxqHX0hzpZ29lP0DVnl1xmvTTOYmtvaN2ACx3p0uoEYcQlmoGFktHhr3DiQKgjp0THpR8uGYPvP1qQzsbUocdOkh+
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc2eb804-26c1-493b-e9e6-08d817f9acaf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 04:47:18.6529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KpnsKKcCH5PRBCGiFkuZTeGNsO5vbqyiMNaX7VPqbC+4/8UR6PK9CdRliZj8ydjW7oHzpm3RmIt/Cpn8czcH3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Flow steering core layer is independent of the eswitch layer.
Hence avoid fs_core dependency on eswitch.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 10 ----------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h | 10 ++++++++++
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 67e09902bd88b..522cadc09149a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -44,16 +44,6 @@
 #include "lib/mpfs.h"
 #include "en/tc_ct.h"
 
-#define FDB_TC_MAX_CHAIN 3
-#define FDB_FT_CHAIN (FDB_TC_MAX_CHAIN + 1)
-#define FDB_TC_SLOW_PATH_CHAIN (FDB_FT_CHAIN + 1)
-
-/* The index of the last real chain (FT) + 1 as chain zero is valid as well */
-#define FDB_NUM_CHAINS (FDB_FT_CHAIN + 1)
-
-#define FDB_TC_MAX_PRIO 16
-#define FDB_TC_LEVELS_PER_PRIO 2
-
 #ifdef CONFIG_MLX5_ESWITCH
 
 #define ESW_OFFLOADS_DEFAULT_NUM_GROUPS 15
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 13e2fb79c21ae..e47a669839356 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -41,7 +41,6 @@
 #include "diag/fs_tracepoint.h"
 #include "accel/ipsec.h"
 #include "fpga/ipsec.h"
-#include "eswitch.h"
 
 #define INIT_TREE_NODE_ARRAY_SIZE(...)	(sizeof((struct init_tree_node[]){__VA_ARGS__}) /\
 					 sizeof(struct init_tree_node))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 825b662f809b4..afe7f0bffb939 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -39,6 +39,16 @@
 #include <linux/llist.h>
 #include <steering/fs_dr.h>
 
+#define FDB_TC_MAX_CHAIN 3
+#define FDB_FT_CHAIN (FDB_TC_MAX_CHAIN + 1)
+#define FDB_TC_SLOW_PATH_CHAIN (FDB_FT_CHAIN + 1)
+
+/* The index of the last real chain (FT) + 1 as chain zero is valid as well */
+#define FDB_NUM_CHAINS (FDB_FT_CHAIN + 1)
+
+#define FDB_TC_MAX_PRIO 16
+#define FDB_TC_LEVELS_PER_PRIO 2
+
 struct mlx5_modify_hdr {
 	enum mlx5_flow_namespace_type ns_type;
 	union {
-- 
2.26.2

