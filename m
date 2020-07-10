Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B36321ADB0
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgGJDsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:48:25 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:20294
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727807AbgGJDsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:48:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kf97ylpuz565NRZoLK3MuhIs7ltlsT/BjDxxxLT8BdjjfKuCyMczeO6P8hOcHKt1WNMP7Vjb05XuVnPgCciSQXr0qYB04tDfzKlBg+wgYGVcjMuey4Ssgmr4cKwI9q70KnsRhCBfMiwQhcHZYqE4GPAw/LEcEVWIZKDIosVaw2taOqjJxnSo+LXGmi+99BK2DEpVqYhePPshFQzlnOq2ZXBFoWONQYY+5mPI+qgCHtdxkWIKdDmcW20WYZlSPVL9hw5jYFaXsQyyiMG4rWaj1W6sMAQNRxkrKUAYpHTnKm9JYyaTZIg/+b4gCwNJeyVleE9hLG6OQE09xm/LN89Ang==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3a8Asw6cO7+8UdxlU1bgOQ+yCroSktXKRJ3M9Xtmt8=;
 b=SAmANl/pb8RWKA6xOU9znFh3sDUXmt4LDq+JOyflwwM+3VcPP2hJusuHcVeaFd4fCWg/Jn7j4yJt8b3tUm5hgD3o4QZq1Yct+i6wjLvpKapRKP85sOe0XDzkQVjFI1EJPZm6KzqbpT9Vy67y4pxGIsXBhpgX4pLDpjgWX0/ZcKaQzwZJM38R/SNoi7oIepDqstYShoMpo8uZj6htho+ggRyAmaGeyFm8FZR+f+s+LTrOd28qE0JefIIjaVmP94N4LC2ivtPZMEghrFTFxs+Hq2txB2/SaIFlutC5ZQH13oXaB+PfBcgPvkDeY8nCYbt8u/DVd9AjSpw7opR7TlXZ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3a8Asw6cO7+8UdxlU1bgOQ+yCroSktXKRJ3M9Xtmt8=;
 b=rxcIUVwymhi/VwNIaR5HJK2xypDDMbalhUMGGEpM3JQEjUthgxSsHiibwvSw7rE2yYnVzfE8lbOVlJQL2dMa2InsVdyKTb3voIgrPpksQshp8sTVnoIZFT81URcKPSDzEY3GUZ1TvplwTPzF/8VptCAbrESnihA96aZ1aXlpCQ4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 03:48:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:48:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/13] net/mlx5e: CT: Fix releasing ft entries
Date:   Thu,  9 Jul 2020 20:44:32 -0700
Message-Id: <20200710034432.112602-14-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710034432.112602-1-saeedm@mellanox.com>
References: <20200710034432.112602-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:48:07 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: be50fcf0-c470-4326-e38f-08d824840fdd
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4512663DE9AD7AB8D897B237BE650@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:185;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a7oB0yDPQjHS0o2ijlgaREhwfvP186n5yor3EJLYTNKpvdJ6CqCsY0vSJKIr1sxk1RXxckR6w/eg3Fwfpq0oB+KeIPQj9ujoY8vrRwkq7/O98A7bqJWGobvcCNZL9n5P2CMu3v4tRQkvnos6hmm1I0HiCU4x1Eh2H+vktM2gZj8pHuEYmDpSmsJE9hX57osPL5L6QmNIF8QKi3XmxSLo8pZY/pwOIVSCTAh6QXNz+xsBjDsLBd3TGtTtqBwTlIMBChexVD28NFPk8zVMT0OQGqqzlYVCqwM8mjtkCn9pP8ncO/pxdiSFePkAuWO/RY5/puDa3XPdO6JDj07+GtfFI/z5/DyYG6Zl3n+IX5TlajZodK0OQcCeTp6FS0ERsmX3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(2906002)(107886003)(86362001)(8936002)(8676002)(6512007)(5660300002)(83380400001)(16526019)(52116002)(66946007)(54906003)(6486002)(186003)(1076003)(956004)(26005)(66556008)(6666004)(6506007)(36756003)(66476007)(478600001)(2616005)(4326008)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: s/7ZzxL1HPwnFFw+gQ7qPyWKBYl2yTAKwAVjyOcu6iz7CuYRf01J1nRVryoWEbVCeqIZ00sIwEfgrURE+kVIVIAlo/A7Vi1UOeFyg8PEYpj3oyVIdtOj/IfLF/JLEtvvXr3iqCiSBbyG1A5wLSOo5cmXFpHy0Fo3Gx3vA9YqxD4EhS6pG+lWpWmkF4C76mbbwb3nXfISznd8zDaW7pfAxdwLlHaEuMl2eS1rxgyS+FCfiR4nFqOhqtGI6YWif/1WZJB0D86bIiGp/6unQRLC3ludfkejVN96+6ZqtlFKEGlzy3BNvbsfAXtbQRRX57cwTEqP21OlxxW0nRc0aQigoY7thkSawe0uvqd/7IFtyVOE2L1rj8WnEEJpETqy3yjZhTYtt0A2xH8KO4Q92hfTPnTk+JCzyQ0v0EI5OVycprRruLdEmU5J+GHmU+GDuD+prS6jWHATtz9/F1Ldux9CU9rTDox9JY1mJNdVy1gV7W4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be50fcf0-c470-4326-e38f-08d824840fdd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:48:09.5467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWPmrMm7ldlsu1DrPJWWtWa6REtpO94a5FslVGrLDEdLxVRcGMKBkUNVeX3Had47JLE0o0VsuaCjMFlAYzWzrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Before this commit, on ft flush, ft entries were not removed
from the ct_tuple hashtables. Fix it.

Fixes: ac991b48d43c ("net/mlx5e: CT: Offload established flows")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 24 ++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 96225e897064..4c65677feaab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -817,6 +817,19 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 	return err;
 }
 
+static void
+mlx5_tc_ct_del_ft_entry(struct mlx5_tc_ct_priv *ct_priv,
+			struct mlx5_ct_entry *entry)
+{
+	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
+	if (entry->tuple_node.next)
+		rhashtable_remove_fast(&ct_priv->ct_tuples_nat_ht,
+				       &entry->tuple_nat_node,
+				       tuples_nat_ht_params);
+	rhashtable_remove_fast(&ct_priv->ct_tuples_ht, &entry->tuple_node,
+			       tuples_ht_params);
+}
+
 static int
 mlx5_tc_ct_block_flow_offload_del(struct mlx5_ct_ft *ft,
 				  struct flow_cls_offload *flow)
@@ -829,13 +842,7 @@ mlx5_tc_ct_block_flow_offload_del(struct mlx5_ct_ft *ft,
 	if (!entry)
 		return -ENOENT;
 
-	mlx5_tc_ct_entry_del_rules(ft->ct_priv, entry);
-	if (entry->tuple_node.next)
-		rhashtable_remove_fast(&ft->ct_priv->ct_tuples_nat_ht,
-				       &entry->tuple_nat_node,
-				       tuples_nat_ht_params);
-	rhashtable_remove_fast(&ft->ct_priv->ct_tuples_ht, &entry->tuple_node,
-			       tuples_ht_params);
+	mlx5_tc_ct_del_ft_entry(ft->ct_priv, entry);
 	WARN_ON(rhashtable_remove_fast(&ft->ct_entries_ht,
 				       &entry->node,
 				       cts_ht_params));
@@ -1348,7 +1355,8 @@ mlx5_tc_ct_flush_ft_entry(void *ptr, void *arg)
 	struct mlx5_tc_ct_priv *ct_priv = arg;
 	struct mlx5_ct_entry *entry = ptr;
 
-	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
+	mlx5_tc_ct_del_ft_entry(ct_priv, entry);
+	kfree(entry);
 }
 
 static void
-- 
2.26.2

