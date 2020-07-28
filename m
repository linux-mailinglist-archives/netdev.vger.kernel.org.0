Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28432306C0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgG1Joo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:44:44 -0400
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:30084
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728471AbgG1Jon (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:44:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=En93f/Dh/BbvuiAU2CESXetltZk4rKouuAmY8kHo/plEUKSmXQpZ46ZFxOjGbOEdXUjx2cKxsBUas//YJOwKFdIb8kZXzXj92haibhY1ex7kOcbQGA6qGOwAQ9VGEuSJ5dzABwV4rbQNUPYhpmVjZsf5z91YuxhJyMF116R6+mozOtWqEIF+l/Tg0V+2JU2Y+jcwQuT8TTIpv7n0lYSxgwPocRsudg40uSOtZB90XlmZbJDALIgEMJJfkKJ+LG6RT3W6iPlY1DMiiYuyUFl1fh7q8MSnBP0zPZjcJdKOB8n87hNKQsVHc9EhrBWEaZmr4aGUnKRlvrnrspt7eHENKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1yBYrv5oZFV43aF2lT4Wg8tvbvAGPEz71dyyJZvhnE=;
 b=XgfV+hJ4DEfKRJR+mspH1hZ85VuZhjSgvdzdb3mtmYMvSEP0KvTXBKVEBhmjRl2+tlMXHN0UJfNA65IGQbtH/XIGPxwYOWW9h2xk/aqD5xzfhQsDIjDpMaElUiuj2aHvr85OWVhq1yZCb4K0zc1iHaEcpucPm12IVd+1GO9hsKqceawj1h6HC8Fm/UcAnBJF+/bv+FfnYLdQ9P0jdzwzHQstiMhmSNQY7jz1KxJz+SnZZjDiow6N+aEjiyNBDaJsCblMDzw0zdOuLz74Mc5m6B7xsCLKbfkpIod1eINaLDoymngNgsDkmWBkE7AE2RFMK55EeOI0qBDnMu8MKd1k9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1yBYrv5oZFV43aF2lT4Wg8tvbvAGPEz71dyyJZvhnE=;
 b=Ys+O5/Lnx9fcZRRHprBnSPsg7xc98KFYIPCLZfLxcehuhzZkSlOy7k9wwoqtBEKaJOeybi/g/acVg3XIrvPNR7S7TrHuosr3t4/urDgZUSgHoFyvMhIcpz6vfWXxXMIYrKBetDcsfrPxUQ6Ic/c0k9SCn9DRObyfBm2yi7Ke2gw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:44:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:44:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/13] net/mlx5: E-switch, Consider maximum vf vports for steering init
Date:   Tue, 28 Jul 2020 02:44:01 -0700
Message-Id: <20200728094411.116386-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728094411.116386-1-saeedm@mellanox.com>
References: <20200728094411.116386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:217::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:44:34 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cdda2b04-d89c-4fad-3568-08d832dad6ab
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB711791E7BA0920942C786A8BBE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:83;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yfUGt9qIrjCFPIjyT5t/G6kH9CuGXkoU3qXuVTTGY5SvH06WmeRY+Pwyf07x01swfY/4f8OJ42Ds/ahdpWAe0zMxoQw9+0jMG1ui35WV+koImgjDqQ8tQraKY+GEHok3S71nIHcqQ/JzK4w8+ZDkN9u48AM6klqygmTEWTiX2UzNlz2QGo5qBAvr3tzjaS8Pl5hQyme110o7RqTZPllu+c21uqqlzacUM9o/BzhmtFGAzt/8r8R9d+Ww865RIVFcI9sALCZlrBswMyb2EUCeHFtOmJkxmZ6g8vp8f4MDStuXODIwHOX/1k3PUFGg27jPchaQRRx/cKyDmF0TZCEF6SEez2TRDJMx/HvCWzocZLwcO9I/9sdGLMzqzxB69Xrf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(110136005)(54906003)(66946007)(36756003)(478600001)(316002)(1076003)(86362001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UzHV8yGBL1Mvkt3tctD/9jw76807GGvy0ryeL2Jxk/CTfS+zUyBLDtUjsW3VU8D/GE/VE+ynRB3bj3dXaGjUT4nmhleAfKM92toxF4rPLnWVx+Q3+h/eFMGFcTNEjILOvAN0+a7rAEGpEvJHdAk+YX19N054t8gesBL6rw5nI1wK0JHGEAG3y/qiMAqga8UWpMcCWuBs1E+V2686G8JGbB4TwlF0rpa23tmHqsB2+YdJziealv5mXO0SL9MJJfGgwzVPDAWnTMzhNbbb0q+iUWP6yApHUl090EJNAiU/K05v6SPAwcb9Nb+m1TAZzTMMSY7YSwmgrrgE3nCmhJNa7n8j6B2x+9EnAaoQHBWUjs3rynAZz5MjpQTkZkcnQ1HizbtfeaZgmkBB84lOV4fYbslc3ZY9XrduBSXFCJjnvT57zuHqpdYwamTi2OHtCTZEIMUmh4yM6aFZ4jgL0wWYsZkCi01O912IcGORXnt40Wk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdda2b04-d89c-4fad-3568-08d832dad6ab
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:44:36.1259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hb8t5CflqXCWf//GpXpzQnkZ/qV1sb0xPmp6DsWQG8pb94Ufj/afZMi7sEch3lNLZ+8AR6XP9+KW5VIhLISGDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

When eswitch is enabled, VFs might not be enabled. Hence, consider
maximum number of VFs.
This further closes the gap between handling VF vports between ECPF and
PF.

Fixes: ea2128fd632c ("net/mlx5: E-switch, Reduce dependency on num_vfs during mode set")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index db856d70c4f8f..a21b00d6a37d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1986,15 +1986,9 @@ static void esw_destroy_uplink_offloads_acl_tables(struct mlx5_eswitch *esw)
 
 static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 {
-	int num_vfs = esw->esw_funcs.num_vfs;
-	int total_vports;
+	int total_vports = esw->total_vports;
 	int err;
 
-	if (mlx5_core_is_ecpf_esw_manager(esw->dev))
-		total_vports = esw->total_vports;
-	else
-		total_vports = num_vfs + MLX5_SPECIAL_VPORTS(esw->dev);
-
 	memset(&esw->fdb_table.offloads, 0, sizeof(struct offloads_fdb));
 	mutex_init(&esw->fdb_table.offloads.vports.lock);
 	hash_init(esw->fdb_table.offloads.vports.table);
-- 
2.26.2

