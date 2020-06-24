Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C966206A03
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388176AbgFXCVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:21:15 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:63460
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387898AbgFXCVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 22:21:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UwUmUkAl6l/u4Loi8ir3BuFo0PJpoQPcUbdNF5bH76STUb4UXFdCsIUpd8KiiQnyLkmU+9/V+lcCNGXQbucRtVv4fWTWH+GP5JkJyf6GjBgPoSBoLrfaaGSg2GPB/u8T6cgm9x/F56To/wQYWxlFPxJ141Uxx9CjbsgeqqW9uSXTW/PvZvfD7r/46cxIU5yppgiSrlC7VLDIxgTPTsdGSLymwlRAdnI+Z2NfpS7v7c6tlaoxXKIwjo5ZUL8sEBoQ+jE5YUckEdE5GSDTQ3LChgLOf3QjEnAbnUHu/8UVAxaS4cBkKEUfVvR7kvFA/0IX+fxYVT2WKY31Wprh3Pj+Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvKzaRmOsLxjnvu6DyvBKkNP2RRBc1o5N8JkUbB/So8=;
 b=AZGHRj04RtRhvMyefOUtXz9DZZdCr3p+jI080KyVPtG0GV2ZrEe2ct7335HcMYjzdTLLTZGcCuFYSGyVzOuRv6fw9JZXq9Yrg8iKHZWq/4+cpGQR0YBb3XPUcNBzFozBCardQWFqVY9k/19e09D7mWyc+EjTG6eZi+5wB6InUNPjsSk2vMO/ONM8UDwtKy+bZ7AXLEzmCrBbdjpav0eYqtycDgceowL9STEyN0xJGl3eGDAZvcl1mJW2g0VpUCE5Br6sb4JPAjyAq1/RCnrAl0Qu1gNbDfygmmtcOrQZKZqugvZ6sLmnpwdbj0C4IDxjNR3fWM93KMDimSSuaHr4Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cvKzaRmOsLxjnvu6DyvBKkNP2RRBc1o5N8JkUbB/So8=;
 b=nr01D/kH9JCr0slaTUPCiW0xjVDOTZG9HaKKp25U7XGsotjGh3JwrLzbYIG4xHx1DlXA8SZHOF8wMPF6CiUG/Q1NoZDl7hA3K1NpY3PAN/EbOjzHcjDCuiPNya70U7smdIyHch0LipRQdmtwWN3h7ugSh793zJYnFDG6YygkK7w=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7022.eurprd05.prod.outlook.com (2603:10a6:800:184::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 02:21:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 02:21:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 01/10] net/mlx5: Avoid eswitch header inclusion in fs core layer
Date:   Tue, 23 Jun 2020 19:18:16 -0700
Message-Id: <20200624021825.53707-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624021825.53707-1-saeedm@mellanox.com>
References: <20200624021825.53707-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0077.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0077.namprd07.prod.outlook.com (2603:10b6:a03:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 02:21:07 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8d4a35bd-3453-443e-0b7c-08d817e541dd
X-MS-TrafficTypeDiagnostic: VI1PR05MB7022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB70227827F3D941AC2C91CF5ABE950@VI1PR05MB7022.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KEQLSLtlqgQwov4jDAeOfaJhdz+8dr10bmVFhTiV4oI8L54BlkRe/OEM6JG25eSt2xOBJfSLVKE/tIKXuz0X5nLi8kAm8zlfnNN2aqUn3XA8UtXN0T86sBvbisOj+vtnrAMQIMJ5G/xFmcQFqBa8/xej9EqiYL1TF7z1eLycHh6sY0cV1wKvHxAc7X93VH7DKWjxmwpbDgsdGNrgiKpQbQBZLX+oI5OdnMBmoFLEgmGOk9mruCXi4lHCv/oQNwTgOQ/Tp0LnZnQtRlZKEps4cT1n9CQv5sP9s2QuXBq/Ue3S6RG5iy59QZQGh2ye8sO9GB/ZWUKdQl+3JHNOHx5F841FUUcthRpWaf8cMvHxMLDYg8rtV527nAyiAxGuawsv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(8936002)(316002)(478600001)(107886003)(2906002)(2616005)(16526019)(956004)(6666004)(186003)(1076003)(26005)(4326008)(8676002)(5660300002)(6486002)(66556008)(66476007)(83380400001)(6512007)(66946007)(52116002)(6506007)(86362001)(36756003)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bDWAUPXXXLHewkc9moCtKhVJt90aUNnjCmlqW+yw97/IBoqwGGXdk1FrVMsCNGhmJANI1d6n+PnKjMFeXmIDneC81vpL3+QGwwMMGxFvA8KPq7N/gdKjM6RsQeR5OnRYn4DJpPHKgn5dOekSXhFw5x0xvSHuTGjLmsFrI5Ke3JO+tFk1+fKm+CHgPhkIuLEe0OebIGvefUZFsy15Rpeg/FRFTF65hZatsUtiTyfkhlMOQlSaLc8I5UcDq2fGqmT5crfrDDGtdMf6SLdbSwilijtLt8qOMYzQXwIUpUSyz/eKiaQTRIhM95RnlM3HobQU61XEjhIRTqy22CDLnvcaNN19uK5XvnjQY465DWdfelEibJJcBH5q1TVnq85qgc7fEUEMqo3rnajZxgyD+d5mH3YXI2PKpsWDf/8JEQjtBrds9kzA33T8rZKOzJ6BOytb6vsKa1pon2HA/INXM0tNOA5T59k1UPBxHCNl74jZKuI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d4a35bd-3453-443e-0b7c-08d817e541dd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 02:21:09.5078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3nr9l3wBI5FOG+E/TSuqGhhbzFldqAlEez1VDJzq70ds46n31VoUY/RAy7RnCc///cE/GVJS0u1BnScO1jH5LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7022
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

