Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97BF20AC0A
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 08:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgFZGAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 02:00:20 -0400
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:6064
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728155AbgFZGAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 02:00:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxXm+NWl/fP/Fmj/LsXzmxEz7SplmvB7B7g4LlqO4WCq0tklH3XJl8idYH05ihUQPIRYi18iADq1hWLW4tzmLnthl4QTmqLN/XOlAxWMvXV1CuVmdNmJ+WK7F3vlUZiDnlcpdCJYHQYFLv6C9htfjwUKOtDdF3Xf3lYj6Tbn7szOKzsyG5tYYXN4+MSzeD5bfE/vzr6mr8K4vvnWWv7hX1r0p+0C++9XXQ21DPnRaa1OFo4e2m5dSPzBhGtqUDj7x/yPQdZphDMCSL/OINuxNq+1V+XxgeG02hPVmfi6R521JNT45KweuVME+EF+VD2hBt+2CfohI6FXHDJ+58Z3Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PEP/leDWWuO62DHhqf3TW4skcK+HGcB9/dtdR/7s2o=;
 b=iXdAzYgO/zgf4YuV+HW+6r1tUcvH/2KtqMWmHyV9PY3LnxTfsrwqR9jRrC0JmT7gGZnDLIhc6b0jD6zGPk8u2RcXevLHvX2fgql2DCtMN34q6JwjtCZyeawyB+g5/dyrUf5S3RkBSwWJ7hUrovdAQZpHX3oE+U1cFPc3yFq1qpVaZOIjlv2boa56tPon+hlm2Dp2J0OjIpSJBfKOE+OpST50LGo0fUZtGcsRaWqy6yxiVpYEKd9uOdePTodxiYIIEk9BQWzO/ONgIRnMZrmxv0IMubzbFf8gbKzQfcQmTjXiuYI388DaTVwy9LyAbdfRTtvamlgN4NV+diFUW4O9NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PEP/leDWWuO62DHhqf3TW4skcK+HGcB9/dtdR/7s2o=;
 b=phjpfK0MbuEYEwF/ShF3r/JD/BXw32eU975NJu++KziBw9w/WUw1M1Q4CJs5uNtyIRk7yEHoRJ9kD9bEfI+Ov3KGeqYBiwJ/K6EmvWm3TILgqavLxJ3waid8X07JbD2+PJKzfbx0FBoMYNfbEG6ZZMdeKYWlR1+mbIx600Z+qSc=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2445.eurprd05.prod.outlook.com (2603:10a6:800:6a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Fri, 26 Jun
 2020 06:00:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Fri, 26 Jun 2020
 06:00:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 2/3] net/mlx5: Avoid eswitch header inclusion in fs core layer
Date:   Thu, 25 Jun 2020 22:59:42 -0700
Message-Id: <20200626055943.99943-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626055943.99943-1-saeedm@mellanox.com>
References: <20200626055943.99943-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0025.namprd04.prod.outlook.com (2603:10b6:a03:1d0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 06:00:11 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0650249b-b619-4f2d-9b40-08d81996309c
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2445CE6AD8D2DBC563DEB4CEBE930@VI1PR0501MB2445.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aTxTIpaRxz9dXtpPjIIHJSokSsdiTmQJHb6eNsjf3XHSXMcMypG3Lc1evQtOGaLN2IdIjid5EF6Kc7V4deY5L6J9hSu4h4d/kgqKUIBVc3Rg9vdABrGbpbKDvo+D8WvmEnAdJ2hFktioEji3lSrRBwGxHCCqQpv9s8hCS/HytWzOjclFJPFSFvwVRkOy+udhCIl+IJSTiCD4FgfMnNgs9bznuZky4Zl0ox/TqL4CmssskUnR1+XJucaK/UfU/ATMNOcNC+NSJA+NTCBP+E63RGvpH7sXDLgnMuoVG0kNoRf/IXM/vVDYU9N/ixbKa3EB3Cz6IBIKGFNAm8Sz8GHgbDdN/xg9Gw/bL2pjwzkjCuJ3gujtxuyRJvZXYGDVO6Ac
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(4326008)(8676002)(8936002)(52116002)(6486002)(186003)(1076003)(36756003)(107886003)(26005)(2906002)(83380400001)(66556008)(86362001)(6666004)(6512007)(110136005)(66476007)(5660300002)(16526019)(316002)(6506007)(6636002)(450100002)(66946007)(2616005)(478600001)(956004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yaELOcSxVWGSHu8UQmH2XyPRx298VMRgq7M/B/WvNn0lpiuu5y5hLL8Zbx0Ff3TGFDvAlHmo9d0OF8kPsarSPbss/fAEei77TfcBAhcChFpmrQpKEOEEAG/0y4lV6HqSKui4WLVC62gO47w84kSVRgk3cldwvzNFfVGzpW0GhzAXRDtm4f4891gJvYZyJl0y0Tg5/V4nuCQwAC/qxgqKoeuu3naBSrzYffs0GkWuk3QAkNhuWhIXY7qfdEBkJszmAqRKam4frbccDVPXQtDverKxc+TrIgp3uIu5tbPK38GHA1v3RtwTqVXJzgh4baXsdKzLfIoPe17dQsUu8N4tc/+goaixBOmJFWOFYlpP9JtjQJK8lWot8kZf5b6syPsYv/zr8G72XZGZ/ZeJdjUZ5PFwEO8bWIP69ymdUtZ/ZYTFihhB08eWdRROZxxK/TMcIN+5UlG3dT0Gf6fF5Xecs3jWVucpNQ9l8BG3Nz5VpX4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0650249b-b619-4f2d-9b40-08d81996309c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 06:00:12.6082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NoUsIx1h2i+yLW5sFFzwzthSCrpAYy2AzQCf5X8VIK/28ozhkX9H2DDNrkZZCb8/CxzUtD+ipqTcj7TBpGj4rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2445
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
index a5175e98c0b3..bb309b2f77f2 100644
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
index 13e2fb79c21a..e47a66983935 100644
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
index 825b662f809b..afe7f0bffb93 100644
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

