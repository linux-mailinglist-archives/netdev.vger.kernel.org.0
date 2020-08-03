Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE4A23AE57
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgHCUna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:43:30 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:25987
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725863AbgHCUn3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 16:43:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsUg8tyyTa7m71hktVe8B9jpWiSu8KNYq2gN+BIdtSs6p+DcSS3L0XJ/4Y6LDi3yROqgasKC+61qfIuVQTa4kyj1v7+0NviuiivVyE/1gjICco2NupQ+UhIsQkQiCG4SYQmOJ1TTbniU8XU2E16f26zTWnSGa+MoaGkpc91xp4fK5m0hA3qlEur55baVfivYLrlhbCWskK0pgXSXGMV6xE4ES9WPPCjR6jy2vywtMUgJMbi3KAM0w77ByzO8sqDhSBoHZomY7BmkO8SJVySxxqZhJ0YVCwQVy3z7k2SF52JzqFcE83dgXuQgl422Eu7lkvDMp2G1D0tmCK/HzHWymA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmCQGJxF/pg/YlZhFUt0zitbzXurMLjCQgrO/T7bBLs=;
 b=Hy8geKMBh2fBC+aLtyUniZiMcGG0bzHG0LTW0EqiaHL0TSVAXMAU2PgfG9It4VkEzHPdErHmjdyKr18HKSMg3ck4x5B2l71GPhzs8yzNWNW/K4xzM3a5Aueur4wbde0P3imSq5LTcLdMExOMRf+ODtEiilck53EyAe7slCphCdgqTrFxtazdLHqn8JKAsxA/IMXwiG626qjJ5m1t1CS/PzGQcp5v3oxXJfZ5EsTKleTje2pPJbo65DeeDi5XO3+3qub0j63VopByRTXrPhc4MNNbJ3zjJKA6ilADBWEZNTNzvC2YaI2hRoI+4gPPBAp4qeXBtM1n3KbDdJhemqZFhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmCQGJxF/pg/YlZhFUt0zitbzXurMLjCQgrO/T7bBLs=;
 b=TVAOKWQhO4jIrNrIKGtKx5RBcVmCzqeeJSnDVbRGpZrc3APN+3DhveG5GKgThoSRwoeaVffSShZiT/SkcoO0Y91A18wt/NjME//ea52UGgm4ojqXhJT+yRlzeLa3KsS1rYSc8lTJe89qBr0RuUaoX05xPnm+BPfOaoeDM9HcobU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VE1PR05MB7311.eurprd05.prod.outlook.com (2603:10a6:800:1a3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Mon, 3 Aug
 2020 20:42:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366%5]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 20:42:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 2/5] net/mlx5: DR, Change push vlan action sequence
Date:   Mon,  3 Aug 2020 13:41:48 -0700
Message-Id: <20200803204151.120802-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803204151.120802-1-saeedm@mellanox.com>
References: <20200803204151.120802-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:a03:255::22) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0017.namprd10.prod.outlook.com (2603:10b6:a03:255::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Mon, 3 Aug 2020 20:42:52 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 964a398c-6c48-495c-4d07-08d837edcbf2
X-MS-TrafficTypeDiagnostic: VE1PR05MB7311:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR05MB7311B640C785AF4763900F80BE4D0@VE1PR05MB7311.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: itS2E3IY0vdfM4tQ2f0pU0WVFtMbjGTYEXbrRCt+utJTgDSsTd+MWtqlWWow3NSA0ayxe+Z4HkdOHrYMKjes+WNTCyaVF+CGlV575w4yTkpRiBfIohPdkJGdjqbOp2YFRepSKkxMDAXOXw6dJr/awrFGjeeNzq02Q67FVhPxFA2CAeWRzVL0aZi4T5WFSYRT+TgQIuk0Xl1vor/XIdktu+sO6Q5uGyp5DnfA6hYYtY9kd+ZzuLp1vERtPt/9nmmuhUcGE8gjDMmjaCVxOQsptLzZxWBfavXaO3V9ZQoi/f2oZTRxAgzUSGVbCWIbEFPF3CyBBL/eOL3DnQYDFX1agQ6qOuc6i9+dPlMTvl++I146OcOawiPxKFjo7ej1UM88
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(956004)(54906003)(1076003)(478600001)(110136005)(8936002)(5660300002)(2906002)(6666004)(2616005)(86362001)(316002)(16526019)(66946007)(66476007)(66556008)(6486002)(36756003)(6506007)(26005)(8676002)(107886003)(83380400001)(52116002)(6512007)(4326008)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cA15M+JF3q6jwYl3OAzt+5NlCNet+cUN6RzPnJaSAPw0AEP5Y6zqFNZB3en2w5QPSG0WUwLVbAKmHVMpKnO498sBv7Dw0FkskZLYnmL+cM2MmOf2Ias/G1R0kiTCx8cUbEcZjIJxItZXkpuLhH1+jb0XUoILTWIwgi8ZcHGkoovaHp63uedcfz94hGp94mBRA5wgmB0G6k6210/xtG4EOi71SYmLnywDJfjLtg0fhkk0oA5NmH6nSlMFHVGYXxJq/RA8V54qM57hnzDHwuAouEF3DI6BWpk9Yha0pD1IBeQZqEVojidS1Y0KYsSp4Kq4ysKK8TKRR/h1KXGRqzXfMq00AmwvJK3UIgG+vH02JGkOyVfPGgxGz2knfYfCvjhQdZYs5D3wq7L4gMQ2g447yonVBLQ7isAJzcefugGs5BFJO2FefBvPw8utZDSa6VmNOikIzYNDxZsa5ffDZdP0bzXZyvSScL3YiUapZ6n20s+X+go86HGZdtlNZA9qJTH7sKBMOQsmCEIUNWTSIeNGyZVttLUvDXWNM4TVI1PoLt+iPRpGfBubyOrY3IrQdegsKzJskKAWj022tQscCLR2Xt3ADdlAhAE78Lr/BiIcLqlFz0+J7xUIDWZVLdWB5ntTQd07WwSnMSkSKFoUF467VA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 964a398c-6c48-495c-4d07-08d837edcbf2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 20:42:54.5224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YayiiHg+Bgdr5MggZrllyFpopYCFiwvWuPNsbig2CVV+9a7kMieOd92UVXN9+3nk+5SA2/cO8zQKMkBJzkAbbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR05MB7311
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

The DR TX state machine supports the following order:
modify header, push vlan and encapsulation.
Instead fs_dr would pass:
push vlan, modify header and encapsulation.

The above caused the rule creation to fail on invalid action
sequence provided error.

Fixes: 6a48faeeca10 ("net/mlx5: Add direct rule fs_cmd implementation")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/fs_dr.c       | 42 +++++++++----------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 8887b2440c7d5..9b08eb557a311 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -279,29 +279,9 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 
 	/* The order of the actions are must to be keep, only the following
 	 * order is supported by SW steering:
-	 * TX: push vlan -> modify header -> encap
+	 * TX: modify header -> push vlan -> encap
 	 * RX: decap -> pop vlan -> modify header
 	 */
-	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) {
-		tmp_action = create_action_push_vlan(domain, &fte->action.vlan[0]);
-		if (!tmp_action) {
-			err = -ENOMEM;
-			goto free_actions;
-		}
-		fs_dr_actions[fs_dr_num_actions++] = tmp_action;
-		actions[num_actions++] = tmp_action;
-	}
-
-	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2) {
-		tmp_action = create_action_push_vlan(domain, &fte->action.vlan[1]);
-		if (!tmp_action) {
-			err = -ENOMEM;
-			goto free_actions;
-		}
-		fs_dr_actions[fs_dr_num_actions++] = tmp_action;
-		actions[num_actions++] = tmp_action;
-	}
-
 	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_DECAP) {
 		enum mlx5dr_action_reformat_type decap_type =
 			DR_ACTION_REFORMAT_TYP_TNL_L2_TO_L2;
@@ -354,6 +334,26 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 		actions[num_actions++] =
 			fte->action.modify_hdr->action.dr_action;
 
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) {
+		tmp_action = create_action_push_vlan(domain, &fte->action.vlan[0]);
+		if (!tmp_action) {
+			err = -ENOMEM;
+			goto free_actions;
+		}
+		fs_dr_actions[fs_dr_num_actions++] = tmp_action;
+		actions[num_actions++] = tmp_action;
+	}
+
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2) {
+		tmp_action = create_action_push_vlan(domain, &fte->action.vlan[1]);
+		if (!tmp_action) {
+			err = -ENOMEM;
+			goto free_actions;
+		}
+		fs_dr_actions[fs_dr_num_actions++] = tmp_action;
+		actions[num_actions++] = tmp_action;
+	}
+
 	if (delay_encap_set)
 		actions[num_actions++] =
 			fte->action.pkt_reformat->action.dr_action;
-- 
2.26.2

