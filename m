Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A912B1B7F41
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgDXTqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:46:03 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:44128
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729175AbgDXTqC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:46:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWqaGzKhYkBjuZw2Zk3U1xHfum0iQ7EJgRQ38A3kgvGMLsorLhhBwjaFyUjzHLVsQNTcrhlf8/MRaSSgblExKjw60ERjR+H5rHVUBc3/GE8mAcOOmJ9xVqvvckd9qNdCryQ2RTtxRxyAGrRVlu0+amBsgsppxNanNzbqoIXQhFw6y/4yslGul0z020llByZKQ8giQbNEwz629u4hCXLy2E6NTx0A0H6W8vzt3Z9urk5lE4tD7tig74mCeqFAobTmtOpJv6uxAZp+szS36O8LPndkSP2wZtzpxcKuGOBjlQRHShy5Kal/HUeTx/2Qg2W4+KMlnm4NGK8X4qHYYjQUIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ku1q8tuB8ZbsGaXmq85ZSceQYsHpXfnUibrTe+fPvvE=;
 b=BKg6MiJCf+vCUfZN8VC7kfQ3JcDKi0jwwoZ4PBLrXZD2RfxZwNyitV3hW+sUf5C6vTsziPIn6ubCg6rZH6O0jyptZwndsrpEy9E9OdIlY1p133T40+0wpqSbqjIurOCVxAe3BAeYJZPep/7H9BiZt6/iAbr8c/DcFbqa79VBDEy1WrYjkYTEWQv0RoF+qjUTZl6shgeucgSkFWpNH/yap3AtZQcCYRYVu3TcydXrJfXYP1o8nxPG6glpW6AMukWBysABR8b+YmO0YYpfRSS5yI6pCDAJB0OBi0gbBnUWU/Ra3h9cZk3k6tHU9cUVDHDW5+CR4oKvmfrw6aVqv3OuCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ku1q8tuB8ZbsGaXmq85ZSceQYsHpXfnUibrTe+fPvvE=;
 b=suoX3i9tvGWsUgzrT3XC7Bh/WSZaXIbgyTOg7ap+TTFDldol0pRxYz9Ry421pVhZD/3jekOi6TXZb0C5X1wCUu/P6MKJ4rCaOOamumhFS5cfKwYUeRevN5l7i/2+fqS53GnHX1ympIMgY2amzu/BP1FsZerV5IQJzJXFb93ZtdU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5072.eurprd05.prod.outlook.com (2603:10a6:803:61::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 19:45:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 19:45:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Erez Shitrit <erezsh@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH mlx5-next 3/9] net/mlx5: Use aligned variable while allocating ICM memory
Date:   Fri, 24 Apr 2020 12:45:04 -0700
Message-Id: <20200424194510.11221-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200424194510.11221-1-saeedm@mellanox.com>
References: <20200424194510.11221-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0016.namprd06.prod.outlook.com (2603:10b6:a03:d4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 19:45:38 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2198baca-4a97-4213-020d-08d7e888113a
X-MS-TrafficTypeDiagnostic: VI1PR05MB5072:|VI1PR05MB5072:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5072FD51F52EF9287F238200BED00@VI1PR05MB5072.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(6506007)(26005)(2616005)(8936002)(8676002)(316002)(6636002)(36756003)(6666004)(66946007)(66556008)(52116002)(81156014)(478600001)(107886003)(66476007)(6512007)(956004)(5660300002)(110136005)(4326008)(1076003)(54906003)(16526019)(186003)(2906002)(6486002)(86362001)(450100002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3HE97+seu3u2C8M75YXbe6OGL+fx5gMEOGW1nwPTC4QtbqzUQ3/YXaqD6zryQPi6ymFrYiWsEq7AcNzF4n6zxscfSk5n6YRe8E6RRxoUC918aNCZPu5BhvivNrent79qH/D6p5eocX3Ir05okbiivIF0BQj+DZfVV7XCv5wTfTCfsROL4vwWh6R6D49preqdsNL4H3SIoN5ru52Cjz3GQ9vIluFNQfFdlW2hbKyi95CmywKKeOjiNMtl11D1IkvQXrDtpTHiotwxqMTAnjSFcLVoOduRaTXq9pAhVvGZod6jmtgTGq/u1OuSjAcMC/iFWiwNuq+VMwZkXRgYKLFqIl33eCmlQnWYUNH6g163IALOm3/yPONXelc3inzhvCB28neF5Smv5UEzPfOvOclilwZUKUBo1YPkMveufPy4HnqSKCi+B5CnvZafJ672fMt94ciVO3olwDDaubVo6rC4kOvP4kOGJgGta8fRDGlHhE98wpaioCuuF2J+qOMGd9eK
X-MS-Exchange-AntiSpam-MessageData: hxQjr51cSlthcxJITAVfnip+xkA2rlAvcCYQnxlXOI6gDJo3lDjpjDjFjSTa+WruF6bnzt1MKFIHJUZwDHcNkvb069q3XNbv5+sNVUt+LMsmVWUnYDXzP2y5NSWUk7XXryUGrYacw3U7YJX//8MptQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2198baca-4a97-4213-020d-08d7e888113a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 19:45:40.7479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PKNaUh5psbB/mmy718OtvwaKXre2bV0Bnbr4pi5Y+UJGDemOg9jELUCptxGrdkRzWIAwOMPwsNo/kX853IF7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

The alignment value is part of the input structure, so use it and spare
extra memory allocation when is not needed.
Now, using the new ability when allocating icm for Direct-Rule
insertion.
Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c             |  2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/dm.c  | 15 ++++--
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 53 +++++++++----------
 include/linux/mlx5/driver.h                   |  3 +-
 4 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f10675213115..65e0e24d463b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2444,7 +2444,7 @@ static int handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
 	act_size = roundup_pow_of_two(act_size);
 
 	dm->size = act_size;
-	err = mlx5_dm_sw_icm_alloc(dev, type, act_size,
+	err = mlx5_dm_sw_icm_alloc(dev, type, act_size, attr->alignment,
 				   to_mucontext(ctx)->devx_uid, &dm->dev_addr,
 				   &dm->icm_dm.obj_id);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
index 6cbccba56f70..3d5e57ff558c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
@@ -90,7 +90,8 @@ void mlx5_dm_cleanup(struct mlx5_core_dev *dev)
 }
 
 int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
-			 u64 length, u16 uid, phys_addr_t *addr, u32 *obj_id)
+			 u64 length, u32 log_alignment, u16 uid,
+			 phys_addr_t *addr, u32 *obj_id)
 {
 	u32 num_blocks = DIV_ROUND_UP_ULL(length, MLX5_SW_ICM_BLOCK_SIZE(dev));
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {};
@@ -99,6 +100,7 @@ int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
 	unsigned long *block_map;
 	u64 icm_start_addr;
 	u32 log_icm_size;
+	u64 align_mask;
 	u32 max_blocks;
 	u64 block_idx;
 	void *sw_icm;
@@ -136,11 +138,14 @@ int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
 		return -EOPNOTSUPP;
 
 	max_blocks = BIT(log_icm_size - MLX5_LOG_SW_ICM_BLOCK_SIZE(dev));
+
+	if (log_alignment < MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))
+		log_alignment = MLX5_LOG_SW_ICM_BLOCK_SIZE(dev);
+	align_mask = BIT(log_alignment - MLX5_LOG_SW_ICM_BLOCK_SIZE(dev)) - 1;
+
 	spin_lock(&dm->lock);
-	block_idx = bitmap_find_next_zero_area(block_map,
-					       max_blocks,
-					       0,
-					       num_blocks, 0);
+	block_idx = bitmap_find_next_zero_area(block_map, max_blocks, 0,
+					       num_blocks, align_mask);
 
 	if (block_idx < max_blocks)
 		bitmap_set(block_map,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 30d2d7376f56..cc33515b9aba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -95,13 +95,12 @@ static int dr_icm_create_dm_mkey(struct mlx5_core_dev *mdev,
 }
 
 static struct mlx5dr_icm_mr *
-dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool,
-		      enum mlx5_sw_icm_type type,
-		      size_t align_base)
+dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool)
 {
 	struct mlx5_core_dev *mdev = pool->dmn->mdev;
+	enum mlx5_sw_icm_type dm_type;
 	struct mlx5dr_icm_mr *icm_mr;
-	size_t align_diff;
+	size_t log_align_base;
 	int err;
 
 	icm_mr = kvzalloc(sizeof(*icm_mr), GFP_KERNEL);
@@ -111,14 +110,22 @@ dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool,
 	icm_mr->pool = pool;
 	INIT_LIST_HEAD(&icm_mr->mr_list);
 
-	icm_mr->dm.type = type;
-
-	/* 2^log_biggest_table * entry-size * double-for-alignment */
 	icm_mr->dm.length = mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
-							       pool->icm_type) * 2;
+							       pool->icm_type);
+
+	if (pool->icm_type == DR_ICM_TYPE_STE) {
+		dm_type = MLX5_SW_ICM_TYPE_STEERING;
+		log_align_base = ilog2(icm_mr->dm.length);
+	} else {
+		dm_type = MLX5_SW_ICM_TYPE_HEADER_MODIFY;
+		/* Align base is 64B */
+		log_align_base = ilog2(DR_ICM_MODIFY_HDR_ALIGN_BASE);
+	}
+	icm_mr->dm.type = dm_type;
 
-	err = mlx5_dm_sw_icm_alloc(mdev, icm_mr->dm.type, icm_mr->dm.length, 0,
-				   &icm_mr->dm.addr, &icm_mr->dm.obj_id);
+	err = mlx5_dm_sw_icm_alloc(mdev, icm_mr->dm.type, icm_mr->dm.length,
+				   log_align_base, 0, &icm_mr->dm.addr,
+				   &icm_mr->dm.obj_id);
 	if (err) {
 		mlx5dr_err(pool->dmn, "Failed to allocate SW ICM memory, err (%d)\n", err);
 		goto free_icm_mr;
@@ -137,15 +144,18 @@ dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool,
 
 	icm_mr->icm_start_addr = icm_mr->dm.addr;
 
-	/* align_base is always a power of 2 */
-	align_diff = icm_mr->icm_start_addr & (align_base - 1);
-	if (align_diff)
-		icm_mr->used_length = align_base - align_diff;
+	if (icm_mr->icm_start_addr & (BIT(log_align_base) - 1)) {
+		mlx5dr_err(pool->dmn, "Failed to get Aligned ICM mem (asked: %zu)\n",
+			   log_align_base);
+		goto free_mkey;
+	}
 
 	list_add_tail(&icm_mr->mr_list, &pool->icm_mr_list);
 
 	return icm_mr;
 
+free_mkey:
+	mlx5_core_destroy_mkey(mdev, &icm_mr->mkey);
 free_dm:
 	mlx5_dm_sw_icm_dealloc(mdev, icm_mr->dm.type, icm_mr->dm.length, 0,
 			       icm_mr->dm.addr, icm_mr->dm.obj_id);
@@ -200,24 +210,11 @@ static int dr_icm_chunks_create(struct mlx5dr_icm_bucket *bucket)
 	struct mlx5dr_icm_pool *pool = bucket->pool;
 	struct mlx5dr_icm_mr *icm_mr = NULL;
 	struct mlx5dr_icm_chunk *chunk;
-	enum mlx5_sw_icm_type dm_type;
-	size_t align_base;
 	int i, err = 0;
 
 	mr_req_size = bucket->num_of_entries * bucket->entry_size;
 	mr_row_size = mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
 							 pool->icm_type);
-
-	if (pool->icm_type == DR_ICM_TYPE_STE) {
-		dm_type = MLX5_SW_ICM_TYPE_STEERING;
-		/* Align base is the biggest chunk size / row size */
-		align_base = mr_row_size;
-	} else {
-		dm_type = MLX5_SW_ICM_TYPE_HEADER_MODIFY;
-		/* Align base is 64B */
-		align_base = DR_ICM_MODIFY_HDR_ALIGN_BASE;
-	}
-
 	mutex_lock(&pool->mr_mutex);
 	if (!list_empty(&pool->icm_mr_list)) {
 		icm_mr = list_last_entry(&pool->icm_mr_list,
@@ -228,7 +225,7 @@ static int dr_icm_chunks_create(struct mlx5dr_icm_bucket *bucket)
 	}
 
 	if (!icm_mr || mr_free_size < mr_row_size) {
-		icm_mr = dr_icm_pool_mr_create(pool, dm_type, align_base);
+		icm_mr = dr_icm_pool_mr_create(pool);
 		if (!icm_mr) {
 			err = -ENOMEM;
 			goto out_err;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index b60e5ab7906b..b46537a81703 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1080,7 +1080,8 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 struct mlx5_uars_page *mlx5_get_uars_page(struct mlx5_core_dev *mdev);
 void mlx5_put_uars_page(struct mlx5_core_dev *mdev, struct mlx5_uars_page *up);
 int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
-			 u64 length, u16 uid, phys_addr_t *addr, u32 *obj_id);
+			 u64 length, u32 log_alignment, u16 uid,
+			 phys_addr_t *addr, u32 *obj_id);
 int mlx5_dm_sw_icm_dealloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
 			   u64 length, u16 uid, phys_addr_t addr, u32 obj_id);
 
-- 
2.25.3

