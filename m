Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1395B1D5C83
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgEOWt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:49:27 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:33656
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgEOWt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:49:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFdRRJGwKqMJFjp/AsmblWOhSiEtDw/dLaa8P1DUC7UD0Kadcd5d1Rr7EfwX2iG6wgQwEiBaN0XRiquIjDH+ery2QFwYV2Y9g0UpSWKPmSyKEyRNFp3qTja3XgdLEg0lzEInE6rEd+jRb7dodf/GyAaZv5lcZFAE+Ij0LrtGDyqKVMLfgfZP3DZSMCMz0ErKJk3hDgdYEaJVitHvZ/UBzBfnjLpRW7VmnjXBWyBm88rLHj6UZN2hyT/PhDEfV/v/ivuTUwx1BJX0ANuhfnZlr24Up8o2RRF7MDEAUF4Bov349g7J0ltBV847ne6uq++r+6jGeSMLXV8L4RIS2eH5oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRei3lJ6FhG34DqwcPtyi4/iySxWYbwhH56lIXdUiq0=;
 b=grAk2Zpfrzg053AoBOF+kg/6+eAQUZxLe0+sULccLaTMw9luklmH/MXnCefFBCyRMh2KGn/1qSjUbD4SYHf8WlP/V2sTIjrq3H6CKjQWqKB2MQUiSHyroWo9uvS7iw5FxCPJh2UbeaL7Uos0YUQpMEvX2vti2MlPJgfFCaavLiHC+srDfUivZjDjx5P1qRDmRFiG55OBgUWTvw0bltcpXehO7pd/DxX/cQ4neqUQVrCcMi6bj28WLEbfjX8GZl06c/xHMea5jQ5hkeC+pFABT1Zs8fLWDV5fDlca4ZCPLTc3AZdf5Ta7fbTy/y1C92Jp55ZdgRehyG8HwvTzB6s87Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YRei3lJ6FhG34DqwcPtyi4/iySxWYbwhH56lIXdUiq0=;
 b=ZuX1VdvlA0hXSFgJQm6FrO/5LN99Cx3zfEx52Px5Bd3YSgKbPenGThL5h2X/O/+dtgmZVuqQejbat2+21WnCC9+gsMvgqVoxSPTDX59fyVJk/421F5JLVU2pVyWC5zZ/s/wv7PLOqSitjIBZ7ryb1l27kj6Fog9rAXs8j+R5J6U=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3200.eurprd05.prod.outlook.com (2603:10a6:802:1b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 15 May
 2020 22:49:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:49:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/11] net/mlx5: Fix a bug of releasing wrong chunks on > 4K page size systems
Date:   Fri, 15 May 2020 15:48:45 -0700
Message-Id: <20200515224854.20390-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515224854.20390-1-saeedm@mellanox.com>
References: <20200515224854.20390-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0053.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:49:18 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4c41eec0-be97-47e0-d6d6-08d7f922342c
X-MS-TrafficTypeDiagnostic: VI1PR05MB3200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3200884A97A917EEDCF1E37DBEBD0@VI1PR05MB3200.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HVyFL/7/yz1QIn6i3zQqe+fbIiA5xi59qIciN0ivuP76vrbj5jg+wTRtG2qimGxPRmCcbqUD8+7ZbWlGo6TnlCI3xtAbHVXB5IdJxorKX6cIFcQDSERmWGX8I2nHjVoqYdNyslFWwDhke0BRk1RBmz69CpR4NHetzgl26oWVYrhME8MrMjqefFXLNHYINQAaBEJ1uGkeNl1RsRWNRsRO3iXxBje1HdMPloySIaelR47iuXjLBBMt2CEtLBZqAeRrYeR+lFYSTr71pIxbC4zFP5RXrwt6XzI3YFKJo6sIvc1+X8SyYewXZKJDGgMgN31gP96OBdKI10fnwdeCYr3yzXIu9uvUSxWrCqwqtskWNpG5G8ssUA6bsY/oNBpA3L66fdtRF1o2syJwHdGx0kPZJMwnR6USHLMYVd7iIXDzDMVKAO1jm7s2COpZAtbsvjRVqJQnMRfy1PcnGlTjibbJa+kRT0BrIQsu8ADu889JNIuvLYeh7DXJ+/OmvtBdRulS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(16526019)(26005)(107886003)(4326008)(6512007)(6486002)(6666004)(478600001)(66476007)(2616005)(66946007)(66556008)(54906003)(956004)(52116002)(316002)(6506007)(186003)(1076003)(86362001)(5660300002)(8936002)(8676002)(2906002)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QZ+XfBo74UFXwj+YUGhfah+TiKzCIj3eLhtrYV9aI0ylZ1sfl1Jx/3+lfgS6SjJJPCZgi7wdUOC7RW7JAxI1zC6jIHDpze7ORDPnxdkf6SXJ3v4jTy++yRHUfJEeOfTJR6gRgXfpgZ/2USil9GxzpewP26Z/VVi0LGmYyyb0txN6egkYzRYQyAp3hWPP6WdSwnM52/DPuOkrPtu1R81tz18w4BQ5Hc127MvoJC8UHSDeCOLlq4MBM5grcZ/P17pjMqtj6qWh4QuQSXJRSbXWZcFAZkZX39lfzK2Qc04dhidUuQZ4PXu1dk6Hb2AGf+01SYum+XtCphfM3tJI70aKkFuTUICliKaZXvP4TlxHvUOFj3+4lILaDYPlmq8uYROJDcE/nzUS9fcFv9OW31ShhJOkRmPZ29C4PUIfpw5bF43A7UUrORMV7wZ26XObrJc9pGfxktY5NZ7CxyepkFAZfDm0I8o+UTCSNmeet4RNaSw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c41eec0-be97-47e0-d6d6-08d7f922342c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:49:19.9330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Az8WNDHeMErVftkYfjirubI5v0peFIX8hNZi6/cYLafHHkd7McN4lt1dMqHXg7DZkaYEtJLn2EgV8I68tMWgog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

On systems with page size larger than 4K, a fwp object has few 4K chunks.
Fix a bug in fwp free flow where the chunk address was dropped and
fwp->addr was used instead (first chunk address). This caused a wrong
update of fwp->bitmask which later can cause errors in re-alloc fwp
chunk flow.

In order to fix this it, re-factor the release flow:
- Free 4k: Releases a specific 4k chunk inside the fwp, defined by
  starting address.
- Free fwp: Unconditionally release the whole fwp and its resources.
Free addr will call free fwp if all chunks were released, in order to do
code sharing.

In addition, fix npages to count for all released chunks correctly.

Fixes: c6168161f693 ("net/mlx5: Add support for release all pages event")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 44 +++++++++----------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 84f6356edbf8..5ddd18639a1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -188,35 +188,35 @@ static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr, u16 func_id)
 
 #define MLX5_U64_4K_PAGE_MASK ((~(u64)0U) << PAGE_SHIFT)
 
-static void free_fwp(struct mlx5_core_dev *dev, struct fw_page *fwp)
+static void free_fwp(struct mlx5_core_dev *dev, struct fw_page *fwp,
+		     bool in_free_list)
 {
-	int n = (fwp->addr & ~MLX5_U64_4K_PAGE_MASK) >> MLX5_ADAPTER_PAGE_SHIFT;
-
-	fwp->free_count++;
-	set_bit(n, &fwp->bitmask);
-	if (fwp->free_count == MLX5_NUM_4K_IN_PAGE) {
-		rb_erase(&fwp->rb_node, &dev->priv.page_root);
-		if (fwp->free_count != 1)
-			list_del(&fwp->list);
-		dma_unmap_page(dev->device, fwp->addr & MLX5_U64_4K_PAGE_MASK,
-			       PAGE_SIZE, DMA_BIDIRECTIONAL);
-		__free_page(fwp->page);
-		kfree(fwp);
-	} else if (fwp->free_count == 1) {
-		list_add(&fwp->list, &dev->priv.free_list);
-	}
+	rb_erase(&fwp->rb_node, &dev->priv.page_root);
+	if (in_free_list)
+		list_del(&fwp->list);
+	dma_unmap_page(dev->device, fwp->addr & MLX5_U64_4K_PAGE_MASK,
+		       PAGE_SIZE, DMA_BIDIRECTIONAL);
+	__free_page(fwp->page);
+	kfree(fwp);
 }
 
-static void free_addr(struct mlx5_core_dev *dev, u64 addr)
+static void free_4k(struct mlx5_core_dev *dev, u64 addr)
 {
 	struct fw_page *fwp;
+	int n;
 
 	fwp = find_fw_page(dev, addr & MLX5_U64_4K_PAGE_MASK);
 	if (!fwp) {
 		mlx5_core_warn_rl(dev, "page not found\n");
 		return;
 	}
-	free_fwp(dev, fwp);
+	n = (addr & ~MLX5_U64_4K_PAGE_MASK) >> MLX5_ADAPTER_PAGE_SHIFT;
+	fwp->free_count++;
+	set_bit(n, &fwp->bitmask);
+	if (fwp->free_count == MLX5_NUM_4K_IN_PAGE)
+		free_fwp(dev, fwp, fwp->free_count != 1);
+	else if (fwp->free_count == 1)
+		list_add(&fwp->list, &dev->priv.free_list);
 }
 
 static int alloc_system_page(struct mlx5_core_dev *dev, u16 func_id)
@@ -340,7 +340,7 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 
 out_4k:
 	for (i--; i >= 0; i--)
-		free_addr(dev, MLX5_GET64(manage_pages_in, in, pas[i]));
+		free_4k(dev, MLX5_GET64(manage_pages_in, in, pas[i]));
 out_free:
 	kvfree(in);
 	if (notify_fail)
@@ -361,8 +361,8 @@ static void release_all_pages(struct mlx5_core_dev *dev, u32 func_id,
 		p = rb_next(p);
 		if (fwp->func_id != func_id)
 			continue;
-		free_fwp(dev, fwp);
-		npages++;
+		npages += (MLX5_NUM_4K_IN_PAGE - fwp->free_count);
+		free_fwp(dev, fwp, fwp->free_count);
 	}
 
 	dev->priv.fw_pages -= npages;
@@ -446,7 +446,7 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u32 func_id, int npages,
 	}
 
 	for (i = 0; i < num_claimed; i++)
-		free_addr(dev, MLX5_GET64(manage_pages_out, out, pas[i]));
+		free_4k(dev, MLX5_GET64(manage_pages_out, out, pas[i]));
 
 	if (nclaimed)
 		*nclaimed = num_claimed;
-- 
2.25.4

