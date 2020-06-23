Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03ADD205C33
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387466AbgFWTw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:52:59 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:43142
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387416AbgFWTw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 15:52:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sb1XvRpCu+yWJfHRjRPUyAkX540Ung+QmxgV5iT1cp7H1m02iKDByqAbiUUAdGt3hNHY47+LS56Bq8N3TU6TlHPDg+V2k/ZMRS2KEln8igsau97i5LR/zM5Yis+XdDWdaTi/zJGpschUEUuNTptRPcwOTUWmrIDXShOb+bNvkN+ziZH3XYXcg8cRdbIsLZoCx9ll8E2OUqbqPTtRPTUGRkA61/dNX5I2Yh1MGWiTGkUko6qe2aD6ilgxg2U7HZvP8D4z+8AS8CApXIm4RgY4XQnHriyV8RPqYImFcLOCpNW1igEUP3SP9JhOtjhS5AqyjpgOoHFaQN6fHXNr4ah62w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFqTXBraYGCbBSxZCk8uIqaxR0Hz7j4WN9IjLhgr8Os=;
 b=bZANUEj3DXFmEXzgW3iACX/tPAhZl98K3vHVJF1tAMe9dzpAnUtCl42q2lPAJ5gN0uOYQFNuADMP3eeXswP87QN2V9pcGa9YtSQgQOu8PJ4yxHZVKLeWVgPr6mvqz87hYQakneEteVrAz2ITiZGZCPYTxBnz4fYY2mJ0/1psPkIm3UiklkB3eOntinPsn9PVhhL+5//XCJYgQXwidab3noSk9/nuWkt6oIkRzjj3mhHSVTT/IsC5EJAFnZhwWAxm8S/T4YpGtEYrdHhMbH4yM2y/HfaQj+Hn8CopasCsrl6xmE1ryhgooLA+sAmhDRG3Uva5i2DIDq8V1owonahEjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFqTXBraYGCbBSxZCk8uIqaxR0Hz7j4WN9IjLhgr8Os=;
 b=ZlAfr+IxlZvhptWamhmwOoAiWt++9FaSZdYpuQUzOIN8Jmo8s1qANEhLvfOdWqmuEWQZYMnIrI73QUIs0QizgYqkgvqLmJONfWasgUlh82bmNdNjyNLW1E+CCKZwicGd5yXcm2ulg7iu2mcNKResNDgG3Coznnq9/Jo2/WqMaDI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB4824.eurprd05.prod.outlook.com (2603:10a6:20b:6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 19:52:55 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 19:52:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/10] net/mlx5: Avoid eswitch header inclusion in fs core layer
Date:   Tue, 23 Jun 2020 12:52:20 -0700
Message-Id: <20200623195229.26411-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623195229.26411-1-saeedm@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0081.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::22) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0081.namprd11.prod.outlook.com (2603:10b6:a03:f4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 23 Jun 2020 19:52:54 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ba2d6a93-1d33-4804-860b-08d817af058f
X-MS-TrafficTypeDiagnostic: AM6PR05MB4824:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB482412010BB731BCDB0EB9FBBE940@AM6PR05MB4824.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6TAUMpuWFycw8fjbph3NGYgGEWNUKlKkcFxNXrOmDRX2AfHgxWon+7/WH8RKG5RY4kMa3Lri/ez2dWSO6GoAFEWj+gTo0YT9GBNyccTglxlTZLW1rESp61lXNMkbECcyyYd9KEgBaj/0ljb97f6LjH3FFVSTJl8A++dk0cgke471CUewittNEnEQ5Q+DxhuJQXqPC06NCkDZ/RNnwfy16ISAc4E06rpEHWyd0wMxrrZzuCUDKb/4KPO9c0eNuMSSKSyv59Gwwk++hlLUne4j4HxqIvehUqFCHfRrkS500tFmy1IoIBJHvz/Xjx9sxa3cX2z0GLC7B/HD825o0pckgm3N78HHpRPr7IyCgZnGUCEKFA3BUSsB+H0w2IALxnjf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(396003)(346002)(39840400004)(376002)(54906003)(6486002)(52116002)(36756003)(6512007)(478600001)(186003)(16526019)(6506007)(956004)(316002)(2616005)(26005)(86362001)(2906002)(6666004)(1076003)(66476007)(5660300002)(83380400001)(66946007)(4326008)(107886003)(8936002)(8676002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 91x2699/7pla4JfEJXpYpiYH+YlumbzB004oyL2YN90OJ0L0oThRYTUQVr0co3o5XRz9KM/gALklKXTebupH9+oOr6J17X+AeZ6ccR7WcAkcrE73VDo0yMhIt6dtuCqn2yCY4zWnAlfY3TE4V3+APZA0/P1tuvIrLD+sx/lQPBQe41xYaZaxa2ErUgc8C2Uf+sqn7f5ru8Znw3TzUH/YlBzkYda1dt+FUx1wFjzQ9Vb1XYQVlGQqnu96qOjsVI9T5QMA6nR9/8H4fCejcmlh5Fe9KuugeynuAmWjnFupvmozfvzLmlMHqLNqvuwnAItawS5rg4EhsH8O+B5dj8w+uZf6ksUip1o8p/W/eDLyrXwrHwxl9823VsDID+Dpi7WI9De2T51NcQqZTRSXo7zPJtDguye2LLA44ay/IfaOuvWnNd7s2ROqtYJXIZj4mUTNOBNSUA5fmAHIwbPgNPYR+OhR8BoIxABahgg3TvVAxOA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2d6a93-1d33-4804-860b-08d817af058f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 19:52:55.5721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O6V+/bdQ2CSlut+VX9zWVTxXqhU3Fn9sHmhntBNncOHRGf4LJOR4uoDwpf9MVc2NO16OBBz4xMbIIJA768vGmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4824
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Flow steering core layer is independent of the eswitch layer.
Hence avoid fs_core dependency on eswitch.

Fixes: 328edb499f99 ("net/mlx5: Split FDB fast path prio to multiple namespaces")
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

