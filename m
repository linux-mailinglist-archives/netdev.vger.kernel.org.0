Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387031CBF06
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgEII3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:48 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:9905
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727981AbgEII3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhnguxdJe6Y09w/zNdwnZ7gkoWIoDfZTqW123zcSTnb6rrLVyD+4TAQ0SGkegFEN0X3+o8hf/x7MPjYIyNtewMpHKAgZ/kSqnC+oA453n5aHdC6MBjOjkxIe0rtlDMrptcH2QE8bo8eXzZQJgiCqtY76zROkSMZljdmvHdmQVHlamA1XQR2Ql0V6fDJ+Q7RDrZJ3gyFM9uC5oU0irA9WufQkkk5b42fLAPhFmC4EUds3ARQulpUGZZV+9uIgFB8Ia9gBz+B8rbVtrP7K9C+sUZBYh9CsA/QmsGgHZY1/aBVE1tWykoZhhsCbodHSmo3mjNVbKCnLdy1ZdMJfDodrlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlsUd+BRi3CRhOR04v+sLtWvtReH7QUtIOPAKxqpVhc=;
 b=LzhOH5mzyUB+Re50YYm1vDew8pQXMcf05L6SdpmstX0dFsk2s8uDchWBXUb/mO+SqSFhzhKcIQZZi3IW05reJsjTaw7gs5X2eZfA/UQauoNeZ+f+noM5XebDEYvla8Ko8Rh0KabpGCLZux0Q1uoAbDkPLhppMgm80SQXrZGLoEsfxSXFBjWdtbjzNTnvZ9VlUOFMZlfzI1/uhZCzwoh7RoIDjJ6U4eALH11chtN3iNyGY/LB1ZVQEfCKn+U+JhI3ubvkwnm+EeLHQvlPLr48tpLZikht8mgqSxx4xfvK/nWMEbOO9+3Jqle/reFKNU5DaABl9p56l7WVrZ6g51Cppg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlsUd+BRi3CRhOR04v+sLtWvtReH7QUtIOPAKxqpVhc=;
 b=Y343niNFwMANQUs8eKBYnDbiBQl2Jg/0Gf4aOJZgDN8SeZekdbToL45dcc1+w9OgJOdBqeSJdocpdvaBuQlLixQpG7AN4oYj79TbiDsZ0jp2BsOourL3UYpOYVvNPeBRI56ARYoD4P0pbEz4XZegDNFur5LV7PK0ECX4DxCdwTE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:32 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/13] net/mlx5e: kTLS, Fill work queue edge separately in TX flow
Date:   Sat,  9 May 2020 01:28:51 -0700
Message-Id: <20200509082856.97337-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200509082856.97337-1-saeedm@mellanox.com>
References: <20200509082856.97337-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::24) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:30 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cf4185ab-4a5e-483f-668d-08d7f3f31952
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4813C8FC50EB822A8A2C03A4BEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LokQMGS+CnOlaaWuv+y4j7c6Z640wWFbn8U0VKZuCvPGCZaYf6Z4cbreNjz1hNrIqzYZOBVt9i64iLvDBajpxBe3WeCULn7jVlcV/myfl9QKz8VsLSLrkAq9kjUXSQrhgONwWn3WM28Em6QIT3jPLIht3y9+XJ3XaYub6DYSxDeIZKeFKcXF8g0pIb8BgIh5wcLyT4QFY9KGyCAYPoUhTzdcx6IlLR2wQWh0Fq446Q2CVwsDcV8KsOuQWBNS0/yL0UN5gQROGKFDlsIG3vjMm+TMu2/nKQiJi4p3Wf3GsfTCzWAl14R8BepeQPDcI89bSJLjmeDz0vgzXcZuzXWsUTuvdufagb3ozH17Y51XmKdisQrpjqjB0qGPjMTx7o6V7Ml2sM9JCA+FWceIYcyWBXnwrU0FqJLdBXvdjPQR1zy/a04y1T71KHhYzIlV8nMok5r5KwOHKMj925xh75wrOLUooPKmyWWhcdl3+0iSgMNbJsqsXrx9aUch8LUhWCjpJdGsoYqpdIO7lctzmH0KZQfs2xNS8PW1ZX4rfnDKMakn/moYbPcJ7yncTZy53L7m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(33430700001)(107886003)(66946007)(316002)(2906002)(16526019)(8676002)(956004)(54906003)(66476007)(5660300002)(186003)(478600001)(52116002)(86362001)(4326008)(6512007)(6506007)(2616005)(6666004)(26005)(33440700001)(66556008)(36756003)(1076003)(6486002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EXtq1SnEB7dWeAl17Ey+AcsGljcXuXKMSbMbvcpZL0QP85c4C8FJUpljdaNF9H2fET0uGOLt/jiA3xfBxMEgsx5tL10XYFw+WGMEHbmPRT4u3PvWb7j34nTW91iKLOFUFBeqoeUyPC8YImzb0ejD5+KJxkFZCaQbRzn4r21+akdb/WG0bV3Uw9fMM1uYUD0Fl+wD/Wt9ZxGf6k+4VdG0ljhB+DQ5iZmve7bnrq44GOrWEVi545LQVZ58Ni41cCunZjXvYMfdFz4239lTQ/G0QqXkk37GE11PcLN5vLLzLae3Iy8lOJSTn2bqvpMZghWmImbh3tP6m8FShPKGVnHibHFjodZPJ84/PXOdAkvqmJ/1ttr1Z1U/F3mW9iHoKayDKv73MclDLoWHMZTAoendJ8Cf5vgRqPeCM1YlD5bH7zLUZ4qrnUoT890XTfovgqajeDKPtqvxfDKbImVGbwffKBXNMJ6SUTO31SOQZ3cny4Y=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf4185ab-4a5e-483f-668d-08d7f3f31952
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:32.5286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fvhURHONzft7zblt2+r4DPXHyQDS3JWciXXypfyutSUTRddSOSsvJCNbsypoQKCnJgCqLFFxbgYlI6mbZDG0GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

For the static and progress context params WQEs, do the edge
filling separately.
This improves the WQ utilization, code readability, and reduces
the chance of future bugs.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c      | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 352b0a3ef0ad..efc271e24b03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -134,14 +134,14 @@ post_static_params(struct mlx5e_txqsq *sq,
 		   struct mlx5e_ktls_offload_context_tx *priv_tx,
 		   bool fence)
 {
+	u16 pi, num_wqebbs = MLX5E_KTLS_STATIC_WQEBBS;
 	struct mlx5e_umr_wqe *umr_wqe;
-	u16 pi;
 
-	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	pi = mlx5e_txqsq_get_next_pi(sq, num_wqebbs);
 	umr_wqe = MLX5E_TLS_FETCH_UMR_WQE(sq, pi);
 	build_static_params(umr_wqe, sq->pc, sq->sqn, priv_tx, fence);
-	tx_fill_wi(sq, pi, MLX5E_KTLS_STATIC_WQEBBS, 0, NULL);
-	sq->pc += MLX5E_KTLS_STATIC_WQEBBS;
+	tx_fill_wi(sq, pi, num_wqebbs, 0, NULL);
+	sq->pc += num_wqebbs;
 }
 
 static void
@@ -149,14 +149,14 @@ post_progress_params(struct mlx5e_txqsq *sq,
 		     struct mlx5e_ktls_offload_context_tx *priv_tx,
 		     bool fence)
 {
+	u16 pi, num_wqebbs = MLX5E_KTLS_PROGRESS_WQEBBS;
 	struct mlx5e_tx_wqe *wqe;
-	u16 pi;
 
-	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	pi = mlx5e_txqsq_get_next_pi(sq, num_wqebbs);
 	wqe = MLX5E_TLS_FETCH_PROGRESS_WQE(sq, pi);
 	build_progress_params(wqe, sq->pc, sq->sqn, priv_tx, fence);
-	tx_fill_wi(sq, pi, MLX5E_KTLS_PROGRESS_WQEBBS, 0, NULL);
-	sq->pc += MLX5E_KTLS_PROGRESS_WQEBBS;
+	tx_fill_wi(sq, pi, num_wqebbs, 0, NULL);
+	sq->pc += num_wqebbs;
 }
 
 static void
@@ -166,8 +166,6 @@ mlx5e_ktls_tx_post_param_wqes(struct mlx5e_txqsq *sq,
 {
 	bool progress_fence = skip_static_post || !fence_first_post;
 
-	mlx5e_txqsq_get_next_pi(sq, MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS);
-
 	if (!skip_static_post)
 		post_static_params(sq, priv_tx, fence_first_post);
 
-- 
2.25.4

