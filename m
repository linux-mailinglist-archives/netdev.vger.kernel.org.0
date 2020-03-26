Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2221938BF
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgCZGiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:38:52 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727683AbgCZGiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:38:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwq/twi4qrixYF4IxFhCjlJODAsYnYoCFj+DJpSq3kAbWGhG46V2uDGeeXNFAczwKYRwuz2MuUu4nIjPhK6bDcSQlky//oMGMA8Fo6k0rzJhNdQI/sIUJ3P6N2uWqqG5VPMfIJgS42ZmzVV5vZ4MzOvWvj7T4WqZfhkqyLLwSWeYXp5Va+QJwU9Xbvn+JSsiPlSBPboiBFiSbe7s3yOq/OVaV3Gea5bMbZf+BXa09vZdCcgszli01F525/CCbXfiKV/ZSTpJLwz61RQKA0UzHVp+bxTQqLUJD4QxKsV57dVOEP4apVPZMfayP1Mi3Kco+HvO3vTK+e+0Ey54VMohHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s1DzGvJlqwYty7zAfcKImXZ6bAd5YmZIf2sKvFJ0nyc=;
 b=S5vv+oBc0+xBF9VwdA20M0n9a65F566oQ/7VstOrFvzgy6C5D+AiZ8tt+44nv5zrzxv1+H/vW/11BhcZ5kzTzNPT6vKBToCMxp6/YqzQ9hzb0uw2p9aSfadCwdb5pcVd/WrOPAs8JAkh8W1Nx/dhdC9hfu7LGRmknAq8VbV1Nvyvj1qrS1snpHajurYaPdCOf63TCguXFhfJjWKWWOLhQOALBRGTIdUqWDeYEnJcHOTswA1G3hPIW2rNtEy5Dq24P0R9zqBYmwX8PQ/RWKoVNWG/gdV2gVLk2l4f2SQU1Adq2L8Ki4qJM+fWneOkoFOJGctQl+0n15u384lWPMlXYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s1DzGvJlqwYty7zAfcKImXZ6bAd5YmZIf2sKvFJ0nyc=;
 b=cv7rMk5PeM3YzBdCzQsKrZvj6s55JabirFPVza3vLAfTepdRHlXbKbG6z6RoQ8plprWwkrujpMx+bZjH416XL+xKhmWwW6Gy7h7UGGpueFJTJXWAF1hz0spvdU5IINKsQIr+RMIwmQXtYMXZBRBFKTaJaWmfY4o3gwcnPmhxkBo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:38:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:38:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/16] net/mlx5: Simplify matching group searches
Date:   Wed, 25 Mar 2020 23:38:00 -0700
Message-Id: <20200326063809.139919-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326063809.139919-1-saeedm@mellanox.com>
References: <20200326063809.139919-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:38:44 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 56dd245d-6aa0-42bd-7181-08d7d15055c3
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6479748EA7D25A58E7045239BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(6666004)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gQKlx+/S80xgci0PcNRxj+Vug/GcF9/SZGSIDNIrP9vvWHY2Zk6eJAt7FUNrYzJ2vi6YZnoOvwN1QoqjbUOs1GA6gP86PWefn6ofgS9rmAL7H38cdLvxqoVLzbXNWC6FQNzpiHZkn93YGW00iaTs5aJvM3qg+Nh3HyGTvJNHtu51VHF9AhUhoZFyZU+rLNPZe2w4wVh75xPGRMPnN3fqDVOVhYpYZPsSG6B+24MnD0QUYPTj/v6dNY5FMRhRGs8puFDBS4NJ0nk1PRzLfcdH6SWMABiPGAJRzCkWZB2GxCkBXbckxCkp9513Tgsc6WCZi6d5XEeZgP3bC+uszpV/SymqHtWd++hLcwtXwHg0CGfKoNSh2cWbDtvttcGbArElJ4BnfNruTwoiA7mGRAuDC19o/J8cIcWV+Qs6EolrByuzm4//5iT2X39AmNSoHJtzr5xcXtOwR8NONoNmCOgQKhbvteDmIuu1NYAPlFS3mZE8zQwfUtBf94w2D2qNRI78
X-MS-Exchange-AntiSpam-MessageData: ldjBm2whCM5ulpaBvS6zSEoBlvioVWikrlVhB5U3mQ6TQw2sFfz7+7bthwPwnwfXhE0QwlOd2MCG+ClTFFftltDA5BZIlQoXnRbZzVKP1KtgkH4/6PSodvcUydtVr6AVYUWjNVM7Rapwdlq8KEbkaw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56dd245d-6aa0-42bd-7181-08d7d15055c3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:38:46.4714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oHsL+QpbuE65mAT6pIpti+O+N2d6JAD1uFuicFvuFvsM98sg++TLS9VaOncv4RS/fHyVzmplZbnnMbOnBijUfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Instead of using two different structs for searching groups with the
same match, use a single struct and thus simplify the code, make it more
readable and smaller size which means less code cache misses.

         text    data     bss     dec     hex
before: 35524    2744       0   38268    957c
after:  35038    2744       0   37782    9396

When testing add 70000 rules, delete all the rules, and repeat three
times taking the average, we get (time in seconds):

Before the change: insert 16.80, delete 11.02
After the change:  insert 16.55, delete 10.95

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 41 +++++--------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index c93bd55fab06..a9ec40ca7893 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1577,28 +1577,19 @@ struct match_list {
 	struct mlx5_flow_group *g;
 };
 
-struct match_list_head {
-	struct list_head  list;
-	struct match_list first;
-};
-
-static void free_match_list(struct match_list_head *head, bool ft_locked)
+static void free_match_list(struct match_list *head, bool ft_locked)
 {
-	if (!list_empty(&head->list)) {
-		struct match_list *iter, *match_tmp;
+	struct match_list *iter, *match_tmp;
 
-		list_del(&head->first.list);
-		tree_put_node(&head->first.g->node, ft_locked);
-		list_for_each_entry_safe(iter, match_tmp, &head->list,
-					 list) {
-			tree_put_node(&iter->g->node, ft_locked);
-			list_del(&iter->list);
-			kfree(iter);
-		}
+	list_for_each_entry_safe(iter, match_tmp, &head->list,
+				 list) {
+		tree_put_node(&iter->g->node, ft_locked);
+		list_del(&iter->list);
+		kfree(iter);
 	}
 }
 
-static int build_match_list(struct match_list_head *match_head,
+static int build_match_list(struct match_list *match_head,
 			    struct mlx5_flow_table *ft,
 			    const struct mlx5_flow_spec *spec,
 			    bool ft_locked)
@@ -1615,14 +1606,8 @@ static int build_match_list(struct match_list_head *match_head,
 	rhl_for_each_entry_rcu(g, tmp, list, hash) {
 		struct match_list *curr_match;
 
-		if (likely(list_empty(&match_head->list))) {
-			if (!tree_get_node(&g->node))
-				continue;
-			match_head->first.g = g;
-			list_add_tail(&match_head->first.list,
-				      &match_head->list);
+		if (unlikely(!tree_get_node(&g->node)))
 			continue;
-		}
 
 		curr_match = kmalloc(sizeof(*curr_match), GFP_ATOMIC);
 		if (!curr_match) {
@@ -1630,10 +1615,6 @@ static int build_match_list(struct match_list_head *match_head,
 			err = -ENOMEM;
 			goto out;
 		}
-		if (!tree_get_node(&g->node)) {
-			kfree(curr_match);
-			continue;
-		}
 		curr_match->g = g;
 		list_add_tail(&curr_match->list, &match_head->list);
 	}
@@ -1785,9 +1766,9 @@ _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 
 {
 	struct mlx5_flow_steering *steering = get_steering(&ft->node);
-	struct mlx5_flow_group *g;
 	struct mlx5_flow_handle *rule;
-	struct match_list_head match_head;
+	struct match_list match_head;
+	struct mlx5_flow_group *g;
 	bool take_write = false;
 	struct fs_fte *fte;
 	int version;
-- 
2.25.1

