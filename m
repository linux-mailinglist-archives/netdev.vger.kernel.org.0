Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D7A20A671
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404758AbgFYUNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:13:55 -0400
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:6061
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404632AbgFYUNy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 16:13:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAYehgcun8+UtkNYLJlWJ2IEyNjiIsItBNEVWVfKLge+sMLuZefEBDKc4QK+0xEVneaFyTkxco6MqNqqfzyyGoLzgG661umh3sx1CVRpuna2rzkgUFf/EnkU8mP5DzoZNst4MC5V+zPFk3kGGCZoiEI1VanZfQqp66CGHbTRuVSfgJB9ufntGfWk78KfSHf+IgcGdsO1W/cD/Mh9GGulFm6zWAmDYTDcOj7BDYiz2yEuDNuVNyy0aOLM6AHGT5mGgAKnuPcbPgVQd28evpRAIxHXUccPkf3GXozmnkbukhoYn9xcasq81Iw5qs5vo+O61hPJRlU7msSlYg33+Qs+og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvKzaRmOsLxjnvu6DyvBKkNP2RRBc1o5N8JkUbB/So8=;
 b=iwrOajc35diH+e5DJYUMpcgBylbO61XeanTaWWHzEOsIG95C4qOELUkjpJL4sNdUJZZ6i35TUO8TUB1S6IWqPCf55KNva9c/MfU38e+aHwu7ER8QbGQgMp8/ZBg6TDup559PG0fN7goIQoLYRabPIsjLS2Va8t665kzajHVhhbaVt8Et5narNCxtXcpPADJdTYIWkp3CSzJDpygU/KdbMlGrh2WWIAkiLmHr/ufHlEyHW9j/4E7+VdlHApIM9tw3z9vj9OzIdSU8hmrOFW3kYA0jYPp6yb5VWBCOZz002y3kptZrVFPNGz2SGWJz7J4dEiEkMf1VfGiZUEaYm679xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvKzaRmOsLxjnvu6DyvBKkNP2RRBc1o5N8JkUbB/So8=;
 b=n6JI4XWTRG7s0qy6gv7xDDYEIGPnZDWEj7O9qi68Wf+r6Pp1dCfoaXumVDSl7AvyM4Xxa4ro+T6m/Uc19GyWnI6lfrN6cf5tUParv4EuVVPSznmZPuiL4bd30lK+TDOIAHdHXFzhV+lQj+qXpV4hlP3ogKqOCI8rY5wZfcYKE1c=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Thu, 25 Jun
 2020 20:13:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 20:13:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 1/8] net/mlx5: Avoid eswitch header inclusion in fs core layer
Date:   Thu, 25 Jun 2020 13:13:22 -0700
Message-Id: <20200625201329.45679-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625201329.45679-1-saeedm@mellanox.com>
References: <20200625201329.45679-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0005.namprd06.prod.outlook.com (2603:10b6:a03:d4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Thu, 25 Jun 2020 20:13:47 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e874ccc3-abc6-4eb6-1c98-08d8194445a7
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB244896E58267B870ECF06FF5BE920@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gqZtrLurR+6bqDLheBX2Wk+1w1CyLMklwaF0855ZHZA1jzcMKmlCc4dYP8JkLFk6eFTYnpI3LykGapaDhBiqi5jJpJNuSlUCWwyDpH4oRcmWjvA9gGuDNFluVET+xarkqtjhVkLkL7FLj8PZO+ekuWMb2VOKh0ullByN6CjyICu6ignrPWDgOQ/D/9DCviL30Fe+UoWWJzZOZIz2bUvGFYTiwhF8kop0Et0WlqDRV8oIBG+8Nb3xDoAhu61jEoVo6p6jjo7EMyO1BzsVx3+ycQtbAsTjJrKgG5ZWkd3h+u1qnzgNXYmllhKn4QVOe3cTA97jsmigq//4q6ng+0sy8y/onyR0qwND3R1vqUTlFHwAt4BuWgcq/fbc/9eeMkvx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(8676002)(4326008)(2616005)(6666004)(1076003)(316002)(956004)(66476007)(6506007)(186003)(8936002)(66556008)(16526019)(52116002)(66946007)(26005)(2906002)(54906003)(6512007)(478600001)(86362001)(6486002)(5660300002)(36756003)(83380400001)(107886003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VnvH1bSQMJff6oKY58QkT3dErbdk4U2dcLyxdzb9KDNK7kQEOOqrOt6RMP01Yp4PekwdUCuVb2lQqGTlraXdh0z5V41r1fm2k/rMdmhTNOmtl9YXQ0b0HPJXPLpQiqISzc68B52RaKRqtlOE8i4SIEACXYUFmR+0bMaKqkanpiQvZvQuXvwrcRciOsSo/DYmwg+fUVD9US0iaPH5ViyLNw/ZD5YGRot+ooIBbyAEd8e9Y1k/QTqMcnVNcgESV7SP8IbQNpo/BiyfY7HMMaWWDE0ou9kgi69JlTCr8LjoPmalfSQycz1OvWJCawQYaeNhivcQ83E7pmHTOy24Cs8BdtWjug93QlxurY2uaJC4j7s1gPNPbfJnSk/Nb64qbh1jKE5fsu4LhX9zOzHWTVwpq4ehKN7bEUKsqxBdJgB/j08ipSxscYcX4oXwPd8ZMbouPc5vXNjpr3gRWsb8/NciNh4OtJnuhVBaULju/V8K/3c=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e874ccc3-abc6-4eb6-1c98-08d8194445a7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 20:13:49.4253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tda0OOmteK1bMb5QZaFNvXcUVrgdN5HJqlMYCq7D1+Qn5lB++FviIQKBOkLTCfnsM3S3AbP8BhOVm2SZ27ReHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
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

