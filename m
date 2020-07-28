Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79DD2306BE
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgG1Joi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:44:38 -0400
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:30084
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728434AbgG1Jog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:44:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNv8XAcd2YbXsB5n+SxmEp1W0Lma0R2FTFc64lKnfoseWZBiaYcXDDiA+1df8uSIeKVNvu1Oiw1up1hhOa5k2q8yNjfyVTsenoLM3gGC34Zkdj9nVfTFqqBcJAx6qM5XdTksjdtgH+g4Zx9Li+LrNRCBfWaMB5wD0ETi9ATdebP8PKdOKgpFbYB6nd325mu2q1AH9NQYunhkr42GWj0rI+spIkFFDlm/PzvAHpY1t0kq9nbH5R+M1r4NXNc4ftJHkV3K52BIdQrwwWLCt7pEFbEyrlCDsCd+Qf/b+HoVwHgLvZfDjXYVaSlXg0dgj1H0PTgoEMWti03JCUkPBESXqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1Hbzvp7UZBGb7G64Vn5IM8Ld4iZbK5GxYeA1uoNNMU=;
 b=YZ7JjYSswXG67xiwzj0Yo2kZFG298BcyV8QD9ll7pGQ4krxF5j4AButkIOb7h6jHVBE3hiEzXkWuDMjheOF3KxkO4I++30n/srrZ9Ypwxew82L2GMBkQIqKbwkLHHZWeF9XOi2ajp9l0b3sjOpCJ4ZTq3mOgG3iBgNAv1Q0aXkFhaQpxwqCKFiPuaFr7iN9NOrOlHErQ5qNq4rC3Wf0jDg6EeB9gpkEN9nFj+tbeK4OioezUjsNLoWVT1Wg/rNtWNqQ55lYTvBaKhvWKSPrZ+i4sblWDIfu0zZ6E8nD682W/OGgN9GV4XuJCfd+zgiKNwy2nCCbM+WhrE+wMa/Nqhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1Hbzvp7UZBGb7G64Vn5IM8Ld4iZbK5GxYeA1uoNNMU=;
 b=NvnV9BtAHdrvzEZqTjidN8uXH1irF0fuRCXcnP+fzUGYsZclOYwfVwJ8T+gmEGH6sziPkSwOdw05fIpZSYmdH+a44ojyDDZhp2ywsSh94Zk4sbX+NpqtMsLdcdVqvbdETBbUDrzlOdCbt9pexoaKHyLRbXuKjxe4vvfTZWokTKE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:44:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:44:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/13] net/mlx5: Hold pages RB tree per VF
Date:   Tue, 28 Jul 2020 02:43:59 -0700
Message-Id: <20200728094411.116386-2-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:44:28 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c5267d1e-e5ea-45b9-7cb7-08d832dad32e
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7117AB9B5F9B6E02F85769AEBE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qVsJsI1sNBJw+IqYUlBw4CR8FCf/fphYA4M1if95xoPAgjAamQ1+4wTmwhlrmKcgKzcPytbCldixbVjLvxDJXiBHDjomkbAtvFvtGEZOkLFe/7Wf6pFDgVUk8juYRucxPUL97FfJuEQ+P/JWK6Yj4JVoT+Ow+Kk6cxJ1KXBqHQwSTa8zqFImxXLUONcqMdW+09GurV3QgWPy+csiICe9VRnRf71Ad71SQsCs1RnwACw1+nj8rv+feIGbg9bA4u2obtNUyk/CHey0P+oUBfzDnoRFLr7WFm3pM26iYr34oqI+8YR+veUofQvZfjGg6dMNK1shXT9tXEoWGNll+zq0Liym6H0LM8+FpULQEh+BEgbn5Iem/66huCEVGQCKxvuC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(110136005)(54906003)(66946007)(36756003)(478600001)(316002)(1076003)(86362001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DVnkK0JFAGO/l+W8J7BJF4xmKHmUH/IsmJERX82lAAp8P9dsaG02SFZYh2+JuzIjgrPQgrxdnhLPAXVnTQWca/M+ttFz9wpfotvpZ4voS0EZXWzbbRIg+IvGB+ZyQiEwWQT4CkLUvw4GgbwQeCuXoTuLJIX06RIOmhXhmnkRp5GJKZ/sP77If0loc+dJiYVMlFIy9zqPbMivkoj2WELVUbL4Qyn/gxo59SsMupHCYMrrvMJ53k+LTiD28PrkUufsVenTd3DPR5a3rD8s18JF3Xrhk60oNI1KNQv6qbe+TqX4y3vD0Y91XIr3iz45MjgU/Zp2H8HqdqlvTvkrk0nD8pCIUzRjO3xwLBZEi0vyJKUsc6cNUEV1p9OAoXRolYUPmutN32m67nCsryaLxrn6oIaj525T4kk84mIN7tCLd36Isw+IDtCcw6MxdQmpR9ROTYqfBtN+LKl/6OKOM2PNXya+Bo/1xe5exShbk3llit0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5267d1e-e5ea-45b9-7cb7-08d832dad32e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:44:30.5329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+ydLGsKpjXYEUXiPe320XP6zu+5+VDr2nTxDJwa2Xg5wZ2Wv6eCJ7kqri4uQhWAY10y7/WeZS2NZ7LR2GfM3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Per page request event, FW request to allocated or release pages for a
single function. Driver maintains FW pages object per function, so there
is no need to hold one global page data-base. Instead, have a page
data-base per function, which will improve performance release flow in all
cases, especially for "release all pages".

As the range of function IDs is large and not sequential, use xarray to
store a per function ID page data-base, where the function ID is the key.

Upon first allocation of a page to a function ID, create the page
data-base per function. This data-base will be released only at pagealloc
mechanism cleanup.

NIC: ConnectX-4 Lx
CPU: Intel(R) Xeon(R) CPU E5-2650 v2 @ 2.60GHz
Test case: 32 VFs, measure release pages on one VF as part of FLR
Before: 0.021 Sec
After:  0.014 Sec

The improvement depends on amount of VFs and memory utilization
by them. Time measurements above were taken from idle system.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 142 +++++++++++++-----
 include/linux/mlx5/driver.h                   |   2 +-
 2 files changed, 105 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 5ddd18639a1ee..1b20e3397ddef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/mlx5/driver.h>
+#include <linux/xarray.h>
 #include "mlx5_core.h"
 #include "lib/eq.h"
 
@@ -73,15 +74,45 @@ enum {
 	MLX5_NUM_4K_IN_PAGE		= PAGE_SIZE / MLX5_ADAPTER_PAGE_SIZE,
 };
 
+static struct rb_root *page_root_per_func_id(struct mlx5_core_dev *dev, u16 func_id)
+{
+	struct rb_root *root;
+	int err;
+
+	root = xa_load(&dev->priv.page_root_xa, func_id);
+	if (root)
+		return root;
+
+	root = kzalloc(sizeof(*root), GFP_KERNEL);
+	if (!root)
+		return ERR_PTR(-ENOMEM);
+
+	err = xa_insert(&dev->priv.page_root_xa, func_id, root, GFP_KERNEL);
+	if (err) {
+		kfree(root);
+		return ERR_PTR(err);
+	}
+
+	*root = RB_ROOT;
+
+	return root;
+}
+
 static int insert_page(struct mlx5_core_dev *dev, u64 addr, struct page *page, u16 func_id)
 {
-	struct rb_root *root = &dev->priv.page_root;
-	struct rb_node **new = &root->rb_node;
 	struct rb_node *parent = NULL;
+	struct rb_root *root;
+	struct rb_node **new;
 	struct fw_page *nfp;
 	struct fw_page *tfp;
 	int i;
 
+	root = page_root_per_func_id(dev, func_id);
+	if (IS_ERR(root))
+		return PTR_ERR(root);
+
+	new = &root->rb_node;
+
 	while (*new) {
 		parent = *new;
 		tfp = rb_entry(parent, struct fw_page, rb_node);
@@ -111,13 +142,20 @@ static int insert_page(struct mlx5_core_dev *dev, u64 addr, struct page *page, u
 	return 0;
 }
 
-static struct fw_page *find_fw_page(struct mlx5_core_dev *dev, u64 addr)
+static struct fw_page *find_fw_page(struct mlx5_core_dev *dev, u64 addr,
+				    u32 func_id)
 {
-	struct rb_root *root = &dev->priv.page_root;
-	struct rb_node *tmp = root->rb_node;
 	struct fw_page *result = NULL;
+	struct rb_root *root;
+	struct rb_node *tmp;
 	struct fw_page *tfp;
 
+	root = xa_load(&dev->priv.page_root_xa, func_id);
+	if (WARN_ON_ONCE(!root))
+		return NULL;
+
+	tmp = root->rb_node;
+
 	while (tmp) {
 		tfp = rb_entry(tmp, struct fw_page, rb_node);
 		if (tfp->addr < addr) {
@@ -191,7 +229,13 @@ static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr, u16 func_id)
 static void free_fwp(struct mlx5_core_dev *dev, struct fw_page *fwp,
 		     bool in_free_list)
 {
-	rb_erase(&fwp->rb_node, &dev->priv.page_root);
+	struct rb_root *root;
+
+	root = xa_load(&dev->priv.page_root_xa, fwp->func_id);
+	if (WARN_ON_ONCE(!root))
+		return;
+
+	rb_erase(&fwp->rb_node, root);
 	if (in_free_list)
 		list_del(&fwp->list);
 	dma_unmap_page(dev->device, fwp->addr & MLX5_U64_4K_PAGE_MASK,
@@ -200,12 +244,12 @@ static void free_fwp(struct mlx5_core_dev *dev, struct fw_page *fwp,
 	kfree(fwp);
 }
 
-static void free_4k(struct mlx5_core_dev *dev, u64 addr)
+static void free_4k(struct mlx5_core_dev *dev, u64 addr, u32 func_id)
 {
 	struct fw_page *fwp;
 	int n;
 
-	fwp = find_fw_page(dev, addr & MLX5_U64_4K_PAGE_MASK);
+	fwp = find_fw_page(dev, addr & MLX5_U64_4K_PAGE_MASK, func_id);
 	if (!fwp) {
 		mlx5_core_warn_rl(dev, "page not found\n");
 		return;
@@ -340,7 +384,7 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 
 out_4k:
 	for (i--; i >= 0; i--)
-		free_4k(dev, MLX5_GET64(manage_pages_in, in, pas[i]));
+		free_4k(dev, MLX5_GET64(manage_pages_in, in, pas[i]), func_id);
 out_free:
 	kvfree(in);
 	if (notify_fail)
@@ -351,16 +395,19 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 static void release_all_pages(struct mlx5_core_dev *dev, u32 func_id,
 			      bool ec_function)
 {
+	struct rb_root *root;
 	struct rb_node *p;
 	int npages = 0;
 
-	p = rb_first(&dev->priv.page_root);
+	root = xa_load(&dev->priv.page_root_xa, func_id);
+	if (WARN_ON_ONCE(!root))
+		return;
+
+	p = rb_first(root);
 	while (p) {
 		struct fw_page *fwp = rb_entry(p, struct fw_page, rb_node);
 
 		p = rb_next(p);
-		if (fwp->func_id != func_id)
-			continue;
 		npages += (MLX5_NUM_4K_IN_PAGE - fwp->free_count);
 		free_fwp(dev, fwp, fwp->free_count);
 	}
@@ -378,6 +425,7 @@ static void release_all_pages(struct mlx5_core_dev *dev, u32 func_id,
 static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 			     u32 *in, int in_size, u32 *out, int out_size)
 {
+	struct rb_root *root;
 	struct fw_page *fwp;
 	struct rb_node *p;
 	u32 func_id;
@@ -391,12 +439,14 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 	npages = MLX5_GET(manage_pages_in, in, input_num_entries);
 	func_id = MLX5_GET(manage_pages_in, in, function_id);
 
-	p = rb_first(&dev->priv.page_root);
+	root = xa_load(&dev->priv.page_root_xa, func_id);
+	if (WARN_ON_ONCE(!root))
+		return -EEXIST;
+
+	p = rb_first(root);
 	while (p && i < npages) {
 		fwp = rb_entry(p, struct fw_page, rb_node);
 		p = rb_next(p);
-		if (fwp->func_id != func_id)
-			continue;
 
 		MLX5_ARRAY_SET64(manage_pages_out, out, pas, i, fwp->addr);
 		i++;
@@ -446,7 +496,7 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u32 func_id, int npages,
 	}
 
 	for (i = 0; i < num_claimed; i++)
-		free_4k(dev, MLX5_GET64(manage_pages_out, out, pas[i]));
+		free_4k(dev, MLX5_GET64(manage_pages_out, out, pas[i]), func_id);
 
 	if (nclaimed)
 		*nclaimed = num_claimed;
@@ -560,35 +610,49 @@ static int optimal_reclaimed_pages(void)
 	return ret;
 }
 
-int mlx5_reclaim_startup_pages(struct mlx5_core_dev *dev)
+static int mlx5_reclaim_root_pages(struct mlx5_core_dev *dev,
+				   struct rb_root *root, u16 func_id)
 {
 	unsigned long end = jiffies + msecs_to_jiffies(MAX_RECLAIM_TIME_MSECS);
-	struct fw_page *fwp;
-	struct rb_node *p;
-	int nclaimed = 0;
-	int err = 0;
 
-	do {
-		p = rb_first(&dev->priv.page_root);
-		if (p) {
-			fwp = rb_entry(p, struct fw_page, rb_node);
-			err = reclaim_pages(dev, fwp->func_id,
-					    optimal_reclaimed_pages(),
-					    &nclaimed, mlx5_core_is_ecpf(dev));
-
-			if (err) {
-				mlx5_core_warn(dev, "failed reclaiming pages (%d)\n",
-					       err);
-				return err;
-			}
-			if (nclaimed)
-				end = jiffies + msecs_to_jiffies(MAX_RECLAIM_TIME_MSECS);
+	while (!RB_EMPTY_ROOT(root)) {
+		int nclaimed;
+		int err;
+
+		err = reclaim_pages(dev, func_id, optimal_reclaimed_pages(),
+				    &nclaimed, mlx5_core_is_ecpf(dev));
+		if (err) {
+			mlx5_core_warn(dev, "failed reclaiming pages (%d) for func id 0x%x\n",
+				       err, func_id);
+			return err;
 		}
+
+		if (nclaimed)
+			end = jiffies + msecs_to_jiffies(MAX_RECLAIM_TIME_MSECS);
+
 		if (time_after(jiffies, end)) {
 			mlx5_core_warn(dev, "FW did not return all pages. giving up...\n");
 			break;
 		}
-	} while (p);
+	}
+
+	return 0;
+}
+
+int mlx5_reclaim_startup_pages(struct mlx5_core_dev *dev)
+{
+	struct rb_root *root;
+	unsigned long id;
+	void *entry;
+
+	xa_for_each(&dev->priv.page_root_xa, id, entry) {
+		root = entry;
+		mlx5_reclaim_root_pages(dev, root, id);
+		xa_erase(&dev->priv.page_root_xa, id);
+		kfree(root);
+	}
+
+	WARN_ON(!xa_empty(&dev->priv.page_root_xa));
 
 	WARN(dev->priv.fw_pages,
 	     "FW pages counter is %d after reclaiming all pages\n",
@@ -605,17 +669,19 @@ int mlx5_reclaim_startup_pages(struct mlx5_core_dev *dev)
 
 int mlx5_pagealloc_init(struct mlx5_core_dev *dev)
 {
-	dev->priv.page_root = RB_ROOT;
 	INIT_LIST_HEAD(&dev->priv.free_list);
 	dev->priv.pg_wq = create_singlethread_workqueue("mlx5_page_allocator");
 	if (!dev->priv.pg_wq)
 		return -ENOMEM;
 
+	xa_init(&dev->priv.page_root_xa);
+
 	return 0;
 }
 
 void mlx5_pagealloc_cleanup(struct mlx5_core_dev *dev)
 {
+	xa_destroy(&dev->priv.page_root_xa);
 	destroy_workqueue(dev->priv.pg_wq);
 }
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 6a97ad601991e..a0fcc4d13e93a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -541,7 +541,7 @@ struct mlx5_priv {
 	/* pages stuff */
 	struct mlx5_nb          pg_nb;
 	struct workqueue_struct *pg_wq;
-	struct rb_root		page_root;
+	struct xarray           page_root_xa;
 	int			fw_pages;
 	atomic_t		reg_pages;
 	struct list_head	free_list;
-- 
2.26.2

