Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F72C1C03CA
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgD3RVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:21:19 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6237
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726785AbgD3RVS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:21:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHBSr8EPBS/qplAueYCA/hu04/HLE3wxTYYlUKCIUcOjG+uObVBY6I6y9oVbderAV6BeSfNZJ/JPo8DuuR0w+Fe4n2h+xXVxHABKsh2I+YI1A4r+k685095BvhwS8GbewpBnMLyN0dY6bNL83Bk0w2G6YuHJ3sWIl02tLRUCIXUZ3JQq+3wodwWyGealiHZ9x8Zd+cbQea+SowK0BPicw/ENZPlA9m6aBLruDCzCTawiZ9LKPvWo++G4OM32S/s4FrBTL8i0d7WRIbzW7WL9bK0+ukPgHqkjWwR3FveWMhgn/AvH8KOM2NcKhhCxgSt+NGAF2GNTFN/U4DIoUe2gIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDdlPKfJc3lkw7trGBUXcEXrDDQMS3CytEtqmA6ka78=;
 b=E17VV5y+u5teBZwG55MXthVVuTKd2xOB2pGms1BS7PxdbR2OuVw6VOKgH1JRwC9/EFks5QKC5Uk8G8rF7WQ8TftwXJwTb/rVOh85tkPgK/5aN5JisqJthjcy/YNoXYWcijztJOjQneAkZwVAoLR2Q0zfQwThO6aGDfc4FiTUVVgIwXuApKvalM9F9fchj1lw0b7yN916tW8GNxPxfD7J3YqEsESGPI5Wt6cylXWEpwM1Tc+001NT4l4OEB0LI6WTq5tY2mehjoiQh0hZQjrG/H433tEby/xDRhrFFhnLqHprCG3oj/bEc+SJrzZnYws0tp9GynmOzbcwSU2tBC0oTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDdlPKfJc3lkw7trGBUXcEXrDDQMS3CytEtqmA6ka78=;
 b=p/a+QDwCffc11mYv20JXyDEJVLIK6n6TAl3vDh1o6jeVp8ar33Qhnn3FjBgCjYOFg5VBLs5Gp0p4UUqRC2I85JPSFbkLENCAR2h/u1wqVor3J3V3a6xu1NcGFGL8S1SSVuCwM6DS4UvXEVblQQuC0qEjy60y7taoeXmL9U76geA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:21:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:21:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/15] net/mlx5: Add helper function to release fw page
Date:   Thu, 30 Apr 2020 10:18:27 -0700
Message-Id: <20200430171835.20812-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:21:09 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 538672b8-fb78-4cf7-15a6-08d7ed2ae10b
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3296417B5A15284194A30896BEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CN+U3AU1v73FyN1L+MDCpOkKssIsFOHvR8DhJFbSMkf5zedyl02gFSQxR4qmt4Y2jS6CENT4TxhiFbGj9esQB37yIWiIJHqqLcugB4OTMvR81g7Uexvd2VEoybasoIpshmtt4mzzX+P6coEdUGuNWspdxdtJaqp9KTMdkGoF2PS3wXIFPjkuwr3VBVAVYq+pdr1oMW3LT0+YcV/mjGsgopBUAG25c5uncXsmcT2SXpyPSk7txAvmt3vowSeB17sa5DMdmWzeKvBgEfuDh2Hmy2v+09lZ6V9GTRZ0i/1BBZ2qxcWNmwrVqfQBEyi7uafymp41dnKuipzXEjRPWcxaKirx/CjLwz3Uj9bEG+A67UR5JiBm/a5uMMiMAjvteOeZXAQRziN+ZUTBMf43ndqLP4qnnrfpcNR+puvPRtAtj6cxJNqNCwD7wH+HqB8fFqJhjC3vk2gxtIdiwBHh31Vd0HyFxJPdGAbfhdRC4WUm6t6mWMACVxzcUuiPk+wBu5VN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OBGW2gJMsXgnSTIILGzlHxPwap1dqltL2MWDHFxFNjHsxCKjH89MptjLVN+VA3PZDdIN+hvaKKtzMhpYtgeUdhHaAbdxSLKezUChYiRHexYjNoYTJ8cOCnbr9V90yQHH7LTOO6SkSQuVRZS8MtKeMFW4lr/witGoSBfk6KMD8TBSSwRoyUifo9sPTDay1ayeayxIESOlJVMwpApwmJcSb8gxpRe7scdSI3WvSRUdtAIHSIYI5EnAgShL+Lcq+j/nIZK4/SG27ZTJ7dE8yp52PibFAAnlFHWF97Sfon5pG0Ew9/7ZMA1vspEn1jsy8z2hfN+fand59h9BcYpjYHvTt/RcVzFprAF16PAWsqZj81kNZTD3QMQq/9bifsQdJZanpBV/5Fvl4kch8jMmKNmXkeI0/Qwa7ULKWgWCq833ekgpWX1PLmNN8C7/DsclWZRx5i5WcxZHirqEMeRJhyO76mSC24SYT9l37X6qF8u8XnfNTah2HluHw2xCBTA2nfbgs7xbghobebibs4aKB1AYaDHt2uxAQYlF28n8mCbPhIpzsN4lXflwADttXMeJh/zOhhd9ewSAtsHYZsoBzPFET5wiA9wuKC3k6qpjv67VF6xGvzSKLJ4xnZhBbtHtjFgdpj7kB2jPuAsmgn4DZwybtrqPShLNvZkWyYgLSS1sChWs77clo6MD5lSSPrYnjxbT1qByrYwl4l1eQh2W2UB9gjaJ5PnFfjUv34WbUXx9hv1mIMTD3HjCmNX3OYWHeRKkcsAIlhcyAQqJ0oqrnE/2kkNjq/ogNzzmF87pOI7pNU8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 538672b8-fb78-4cf7-15a6-08d7ed2ae10b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:21:11.8332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qRPmylurUQP9Z9GESWbv+eeSm9DVoi0Bq+z/ADArIdjl5/pOKh1Nf3Hn0d97x+43wjN8uIhlEWSaIUThiJNoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Factor out the fwp address release page to an helper function, will be
used in the downstream patch.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 30 +++++++++++--------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 3d6f617abb7d..c39907c641a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -181,25 +181,17 @@ static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr)
 
 #define MLX5_U64_4K_PAGE_MASK ((~(u64)0U) << PAGE_SHIFT)
 
-static void free_4k(struct mlx5_core_dev *dev, u64 addr)
+static void free_fwp(struct mlx5_core_dev *dev, struct fw_page *fwp)
 {
-	struct fw_page *fwp;
-	int n;
+	int n = (fwp->addr & ~MLX5_U64_4K_PAGE_MASK) >> MLX5_ADAPTER_PAGE_SHIFT;
 
-	fwp = find_fw_page(dev, addr & MLX5_U64_4K_PAGE_MASK);
-	if (!fwp) {
-		mlx5_core_warn(dev, "page not found\n");
-		return;
-	}
-
-	n = (addr & ~MLX5_U64_4K_PAGE_MASK) >> MLX5_ADAPTER_PAGE_SHIFT;
 	fwp->free_count++;
 	set_bit(n, &fwp->bitmask);
 	if (fwp->free_count == MLX5_NUM_4K_IN_PAGE) {
 		rb_erase(&fwp->rb_node, &dev->priv.page_root);
 		if (fwp->free_count != 1)
 			list_del(&fwp->list);
-		dma_unmap_page(dev->device, addr & MLX5_U64_4K_PAGE_MASK,
+		dma_unmap_page(dev->device, fwp->addr & MLX5_U64_4K_PAGE_MASK,
 			       PAGE_SIZE, DMA_BIDIRECTIONAL);
 		__free_page(fwp->page);
 		kfree(fwp);
@@ -208,6 +200,18 @@ static void free_4k(struct mlx5_core_dev *dev, u64 addr)
 	}
 }
 
+static void free_addr(struct mlx5_core_dev *dev, u64 addr)
+{
+	struct fw_page *fwp;
+
+	fwp = find_fw_page(dev, addr & MLX5_U64_4K_PAGE_MASK);
+	if (!fwp) {
+		mlx5_core_warn(dev, "page not found\n");
+		return;
+	}
+	free_fwp(dev, fwp);
+}
+
 static int alloc_system_page(struct mlx5_core_dev *dev, u16 func_id)
 {
 	struct device *device = dev->device;
@@ -329,7 +333,7 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 
 out_4k:
 	for (i--; i >= 0; i--)
-		free_4k(dev, MLX5_GET64(manage_pages_in, in, pas[i]));
+		free_addr(dev, MLX5_GET64(manage_pages_in, in, pas[i]));
 out_free:
 	kvfree(in);
 	if (notify_fail)
@@ -408,7 +412,7 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u32 func_id, int npages,
 	}
 
 	for (i = 0; i < num_claimed; i++)
-		free_4k(dev, MLX5_GET64(manage_pages_out, out, pas[i]));
+		free_addr(dev, MLX5_GET64(manage_pages_out, out, pas[i]));
 
 	if (nclaimed)
 		*nclaimed = num_claimed;
-- 
2.25.4

