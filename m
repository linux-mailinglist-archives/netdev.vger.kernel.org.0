Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A6621AD19
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 04:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgGJCbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 22:31:09 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:54404
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727050AbgGJCbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 22:31:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnK2vjZMRUE9q6VHTzzWzvoPpenmETJWHwXzzUTt2wfofs+ElU9PeeNaKfDKaYdMuaAmE6r1OjTokAwDnVCTeeumTiZgW0Qp7ktlUaNchUu2edf0pg0OjKadbS6Ks7lWnRo14FgWPPvxDX6q1TrXy9UArSTANi8yJSGDc4aaqauGkqwNtNFZG/V6B+ep9QYwaXBSp4OceBiCcfGKTpOniM+aU9U66w4subu11GdiOE+9X6dBk+GG0wNjvhn0ESbxOlYFR62jHP/JcGprqZr1dwiO6WqFMN0wFdkUO50AvyC9E+q1HFwvgJdnBeDUFVowdiSAE6Dv201dVnNX6oAvCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lZiqtzbKyV6Wg6qgbsemxI8iv0cL02/Gc1CYlY8iJU=;
 b=MtSW9ux3GQLOD/EZuFn/+EO8CYgDSpZ+A0kjOthsREoUdg+nl0GspQb1Ey1DWE9PJRv87y8iF+4kh+SmCR6JjB3XsknMW+nLThwWkMwuuAiYVW2QVlZinqymmJehTMYVUNkjImTiHTI5nYJ7KikyUQv4SfGTwWnPIq8lJWG51OCMCSchhjFrfUW8HU8Vt4qE/+I+qwYruW7sCS6RUNHresUW7sRLFlx8SCcHo83UAglHArvW9mx5TEvJ3id5+FpQk6datmOCOMDBg70iTV8SIU3n3UTDfRa8yAaGOF2VYq/INEpuGhh2Oxe/CV92CyMSBKHkrF+lIFBeKXfKNdGi6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lZiqtzbKyV6Wg6qgbsemxI8iv0cL02/Gc1CYlY8iJU=;
 b=B0D7+3dZtoxejXBzi+ltTm7zVbCv3dpGyK52DKo1lBIdDLYmWtF3MzCMptShaV7t9c/aMWZ1BMBG/D2+LhTuuJNL1RSh3tFgEw/9sPs8QnYnzzVPBxL/IelnXFL+dDtkGv17J0Ve6MvhAtCAIxq/maLgfsIPdFK/wWr82mrFR9M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7120.eurprd05.prod.outlook.com (2603:10a6:800:185::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 02:30:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 02:30:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 4/9] net/mlx5e: Fix usage of rcu-protected pointer
Date:   Thu,  9 Jul 2020 19:30:13 -0700
Message-Id: <20200710023018.31905-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710023018.31905-1-saeedm@mellanox.com>
References: <20200710023018.31905-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0064.namprd06.prod.outlook.com (2603:10b6:a03:14b::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 02:30:55 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a7d78fba-9b2d-4fa5-32ba-08d8247946b3
X-MS-TrafficTypeDiagnostic: VI1PR05MB7120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7120D97BBC1782E91F80617CBE650@VI1PR05MB7120.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:372;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QOkUzQDdo7OQQpasioiH8kL5n2agI8zb0LPKSvHTPKDW5E6D+TkCcudxPvxardLE1hsPUt+gbnyZkRAPf06rLNCGH3LT4RzSNzILP8+VgpEQMeYaeW9Qm4rj6MLfRU7zovH84XCvMyuxV/3c54q/OHGdytKic9McLkX6SAolB4wGEY2zCS8rPCPk7G5QI8svF2eDPhp26kalR0ouuhZfa5f5i6cULj7YtOpT/jYpUP0PmGN+TdZFI6L16bJ3UZe195umpYmgCU/CTTXJNwXce6OOGQYuxayUbSYJRNWBglI5fnrMZWpGGlMwET3SjLVioSkykpjlKevXxWk63ysGTk60gBUwTsSzYstIgA9IjOxB7I/4xxFl6O9LFeydjL9H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(478600001)(26005)(4326008)(86362001)(52116002)(83380400001)(956004)(2906002)(186003)(16526019)(6506007)(2616005)(6666004)(5660300002)(8676002)(8936002)(66946007)(107886003)(66556008)(316002)(66476007)(1076003)(6512007)(110136005)(36756003)(6486002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HSOApY/T91837mNko4WwZPv2qetDrSo2JwoDPSmd8yeNjpnEbWcp53AqFSAmHl6Kd3fvWjl2GpWIxGIksWJyPAC5r1hHys2uabdWdrWEytiFgvjTCmGKgVMfAUqQk/3ruv/wjnq90H1c6gh0HE/lHASOAHxBwYY9FseaKf8AXcWa7RNQii7X+/lfYT5qr/Jk2kSD7RJlmjigS6h7FJj+zZB97WnXJvwXjfxO/eQDoxT7jiBhkaFJQWFWLJpaArTFwqvHPJJZfPwnIq80rL+iatHExrnjPoKNnnio//ZkXUqP7Zwvl+pNFLIF9hmyCQVbFuLraZfWq/9O96DLtdZfSJ5kjFLH6HIezg/mdHOIk76ygqBwiLNGdAY4BLrWamDdSTaFNiNarGp9ItA1o7XpqifmCRqZ5vwPHhuxZtmvcbs0Otae60NO+Je8Sd51mdzknbpvg6gqRNFGiN+opMzeonruPaNuC+e3N3/DhbqvOZc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d78fba-9b2d-4fa5-32ba-08d8247946b3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 02:30:57.0356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OpKEFo/aIdHm0jP17DkPWzddrpV7VAI8rQVyN5W40eTAYmfB/XiWVL6MErVS7Y0HQ75+lDSc2iq2w591HDn3kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

In mlx5e_configure_flower() flow pointer is protected by rcu read lock.
However, after cited commit the pointer is being used outside of rcu read
block. Extend the block to protect all pointer accesses.

Fixes: 553f9328385d ("net/mlx5e: Support tc block sharing for representors")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 75f169aef1cf..cc8412151ca0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4687,13 +4687,12 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 
 	rcu_read_lock();
 	flow = rhashtable_lookup(tc_ht, &f->cookie, tc_ht_params);
-	rcu_read_unlock();
 	if (flow) {
 		/* Same flow rule offloaded to non-uplink representor sharing tc block,
 		 * just return 0.
 		 */
 		if (is_flow_rule_duplicate_allowed(dev, rpriv) && flow->orig_dev != dev)
-			goto out;
+			goto rcu_unlock;
 
 		NL_SET_ERR_MSG_MOD(extack,
 				   "flow cookie already exists, ignoring");
@@ -4701,8 +4700,12 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 				 "flow cookie %lx already exists, ignoring\n",
 				 f->cookie);
 		err = -EEXIST;
-		goto out;
+		goto rcu_unlock;
 	}
+rcu_unlock:
+	rcu_read_unlock();
+	if (flow)
+		goto out;
 
 	trace_mlx5e_configure_flower(f);
 	err = mlx5e_tc_add_flow(priv, f, flags, dev, &flow);
-- 
2.26.2

