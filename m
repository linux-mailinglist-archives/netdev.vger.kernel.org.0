Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA6C305178
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbhA0E26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:28:58 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11313 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389798AbhA0AJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 19:09:22 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a9820000>; Tue, 26 Jan 2021 15:45:06 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:45:05 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Daniel Jurgens <danielj@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net 06/12] net/mlx5: Maintain separate page trees for ECPF and PF functions
Date:   Tue, 26 Jan 2021 15:43:39 -0800
Message-ID: <20210126234345.202096-7-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126234345.202096-1-saeedm@nvidia.com>
References: <20210126234345.202096-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611704706; bh=q8UVNO8tcmSZPJ3b6CLOYUfTzr98VcEcfA9UpBlSEeI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=kHNNMkOYo5dCoO9DpnHoKvgy3EGtX9m2BTOyDaZVk2+8yXCFBv8D5Q8JAHF89XmCc
         UXu15+p6Jcc3eymLenGHwUg/Ee9v0htL+uQaa32wyLuCOhasIfMESJtiner+DUNX7e
         25cT9vBFZlKtZhJv2o5W8qXEJ1HDgc7TqpYOxrIrC2oyu6avgNLBgpKl8fw0vjhIc4
         io3voe+eazjZOiC9YGKkfQr7aL05z6zO8zQchhOTglDCklcvXCEROd1FuqxMKxcsjJ
         ZGmWQL1ShANJNBmUZfQlb7dYelLzAPFqz90lptG3zjvLNf/MYB3FrY9A+JUA98GTPn
         +w/YOaB78baRg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Jurgens <danielj@nvidia.com>

Pages for the host PF and ECPF were stored in the same tree, so the ECPF
pages were being freed along with the host PF's when the host driver
unloaded.

Combine the function ID and ECPF flag to use as an index into the
x-array containing the trees to get a different tree for the host PF and
ECPF.

Fixes: c6168161f693 ("net/mlx5: Add support for release all pages event")
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 58 +++++++++++--------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/=
net/ethernet/mellanox/mlx5/core/pagealloc.c
index eb956ce904bc..eaa8958e24d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -58,7 +58,7 @@ struct fw_page {
 	struct rb_node		rb_node;
 	u64			addr;
 	struct page	       *page;
-	u16			func_id;
+	u32			function;
 	unsigned long		bitmask;
 	struct list_head	list;
 	unsigned		free_count;
@@ -74,12 +74,17 @@ enum {
 	MLX5_NUM_4K_IN_PAGE		=3D PAGE_SIZE / MLX5_ADAPTER_PAGE_SIZE,
 };
=20
-static struct rb_root *page_root_per_func_id(struct mlx5_core_dev *dev, u1=
6 func_id)
+static u32 get_function(u16 func_id, bool ec_function)
+{
+	return func_id & (ec_function << 16);
+}
+
+static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u=
32 function)
 {
 	struct rb_root *root;
 	int err;
=20
-	root =3D xa_load(&dev->priv.page_root_xa, func_id);
+	root =3D xa_load(&dev->priv.page_root_xa, function);
 	if (root)
 		return root;
=20
@@ -87,7 +92,7 @@ static struct rb_root *page_root_per_func_id(struct mlx5_=
core_dev *dev, u16 func
 	if (!root)
 		return ERR_PTR(-ENOMEM);
=20
-	err =3D xa_insert(&dev->priv.page_root_xa, func_id, root, GFP_KERNEL);
+	err =3D xa_insert(&dev->priv.page_root_xa, function, root, GFP_KERNEL);
 	if (err) {
 		kfree(root);
 		return ERR_PTR(err);
@@ -98,7 +103,7 @@ static struct rb_root *page_root_per_func_id(struct mlx5=
_core_dev *dev, u16 func
 	return root;
 }
=20
-static int insert_page(struct mlx5_core_dev *dev, u64 addr, struct page *p=
age, u16 func_id)
+static int insert_page(struct mlx5_core_dev *dev, u64 addr, struct page *p=
age, u32 function)
 {
 	struct rb_node *parent =3D NULL;
 	struct rb_root *root;
@@ -107,7 +112,7 @@ static int insert_page(struct mlx5_core_dev *dev, u64 a=
ddr, struct page *page, u
 	struct fw_page *tfp;
 	int i;
=20
-	root =3D page_root_per_func_id(dev, func_id);
+	root =3D page_root_per_function(dev, function);
 	if (IS_ERR(root))
 		return PTR_ERR(root);
=20
@@ -130,7 +135,7 @@ static int insert_page(struct mlx5_core_dev *dev, u64 a=
ddr, struct page *page, u
=20
 	nfp->addr =3D addr;
 	nfp->page =3D page;
-	nfp->func_id =3D func_id;
+	nfp->function =3D function;
 	nfp->free_count =3D MLX5_NUM_4K_IN_PAGE;
 	for (i =3D 0; i < MLX5_NUM_4K_IN_PAGE; i++)
 		set_bit(i, &nfp->bitmask);
@@ -143,14 +148,14 @@ static int insert_page(struct mlx5_core_dev *dev, u64=
 addr, struct page *page, u
 }
=20
 static struct fw_page *find_fw_page(struct mlx5_core_dev *dev, u64 addr,
-				    u32 func_id)
+				    u32 function)
 {
 	struct fw_page *result =3D NULL;
 	struct rb_root *root;
 	struct rb_node *tmp;
 	struct fw_page *tfp;
=20
-	root =3D xa_load(&dev->priv.page_root_xa, func_id);
+	root =3D xa_load(&dev->priv.page_root_xa, function);
 	if (WARN_ON_ONCE(!root))
 		return NULL;
=20
@@ -194,14 +199,14 @@ static int mlx5_cmd_query_pages(struct mlx5_core_dev =
*dev, u16 *func_id,
 	return err;
 }
=20
-static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr, u16 func_id)
+static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr, u32 function)
 {
 	struct fw_page *fp =3D NULL;
 	struct fw_page *iter;
 	unsigned n;
=20
 	list_for_each_entry(iter, &dev->priv.free_list, list) {
-		if (iter->func_id !=3D func_id)
+		if (iter->function !=3D function)
 			continue;
 		fp =3D iter;
 	}
@@ -231,7 +236,7 @@ static void free_fwp(struct mlx5_core_dev *dev, struct =
fw_page *fwp,
 {
 	struct rb_root *root;
=20
-	root =3D xa_load(&dev->priv.page_root_xa, fwp->func_id);
+	root =3D xa_load(&dev->priv.page_root_xa, fwp->function);
 	if (WARN_ON_ONCE(!root))
 		return;
=20
@@ -244,12 +249,12 @@ static void free_fwp(struct mlx5_core_dev *dev, struc=
t fw_page *fwp,
 	kfree(fwp);
 }
=20
-static void free_4k(struct mlx5_core_dev *dev, u64 addr, u32 func_id)
+static void free_4k(struct mlx5_core_dev *dev, u64 addr, u32 function)
 {
 	struct fw_page *fwp;
 	int n;
=20
-	fwp =3D find_fw_page(dev, addr & MLX5_U64_4K_PAGE_MASK, func_id);
+	fwp =3D find_fw_page(dev, addr & MLX5_U64_4K_PAGE_MASK, function);
 	if (!fwp) {
 		mlx5_core_warn_rl(dev, "page not found\n");
 		return;
@@ -263,7 +268,7 @@ static void free_4k(struct mlx5_core_dev *dev, u64 addr=
, u32 func_id)
 		list_add(&fwp->list, &dev->priv.free_list);
 }
=20
-static int alloc_system_page(struct mlx5_core_dev *dev, u16 func_id)
+static int alloc_system_page(struct mlx5_core_dev *dev, u32 function)
 {
 	struct device *device =3D mlx5_core_dma_dev(dev);
 	int nid =3D dev_to_node(device);
@@ -291,7 +296,7 @@ static int alloc_system_page(struct mlx5_core_dev *dev,=
 u16 func_id)
 		goto map;
 	}
=20
-	err =3D insert_page(dev, addr, page, func_id);
+	err =3D insert_page(dev, addr, page, function);
 	if (err) {
 		mlx5_core_err(dev, "failed to track allocated page\n");
 		dma_unmap_page(device, addr, PAGE_SIZE, DMA_BIDIRECTIONAL);
@@ -328,6 +333,7 @@ static void page_notify_fail(struct mlx5_core_dev *dev,=
 u16 func_id,
 static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 		      int notify_fail, bool ec_function)
 {
+	u32 function =3D get_function(func_id, ec_function);
 	u32 out[MLX5_ST_SZ_DW(manage_pages_out)] =3D {0};
 	int inlen =3D MLX5_ST_SZ_BYTES(manage_pages_in);
 	u64 addr;
@@ -345,10 +351,10 @@ static int give_pages(struct mlx5_core_dev *dev, u16 =
func_id, int npages,
=20
 	for (i =3D 0; i < npages; i++) {
 retry:
-		err =3D alloc_4k(dev, &addr, func_id);
+		err =3D alloc_4k(dev, &addr, function);
 		if (err) {
 			if (err =3D=3D -ENOMEM)
-				err =3D alloc_system_page(dev, func_id);
+				err =3D alloc_system_page(dev, function);
 			if (err)
 				goto out_4k;
=20
@@ -384,7 +390,7 @@ static int give_pages(struct mlx5_core_dev *dev, u16 fu=
nc_id, int npages,
=20
 out_4k:
 	for (i--; i >=3D 0; i--)
-		free_4k(dev, MLX5_GET64(manage_pages_in, in, pas[i]), func_id);
+		free_4k(dev, MLX5_GET64(manage_pages_in, in, pas[i]), function);
 out_free:
 	kvfree(in);
 	if (notify_fail)
@@ -392,14 +398,15 @@ static int give_pages(struct mlx5_core_dev *dev, u16 =
func_id, int npages,
 	return err;
 }
=20
-static void release_all_pages(struct mlx5_core_dev *dev, u32 func_id,
+static void release_all_pages(struct mlx5_core_dev *dev, u16 func_id,
 			      bool ec_function)
 {
+	u32 function =3D get_function(func_id, ec_function);
 	struct rb_root *root;
 	struct rb_node *p;
 	int npages =3D 0;
=20
-	root =3D xa_load(&dev->priv.page_root_xa, func_id);
+	root =3D xa_load(&dev->priv.page_root_xa, function);
 	if (WARN_ON_ONCE(!root))
 		return;
=20
@@ -446,6 +453,7 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 	struct rb_root *root;
 	struct fw_page *fwp;
 	struct rb_node *p;
+	bool ec_function;
 	u32 func_id;
 	u32 npages;
 	u32 i =3D 0;
@@ -456,8 +464,9 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 	/* No hard feelings, we want our pages back! */
 	npages =3D MLX5_GET(manage_pages_in, in, input_num_entries);
 	func_id =3D MLX5_GET(manage_pages_in, in, function_id);
+	ec_function =3D MLX5_GET(manage_pages_in, in, embedded_cpu_function);
=20
-	root =3D xa_load(&dev->priv.page_root_xa, func_id);
+	root =3D xa_load(&dev->priv.page_root_xa, get_function(func_id, ec_functi=
on));
 	if (WARN_ON_ONCE(!root))
 		return -EEXIST;
=20
@@ -473,9 +482,10 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev=
,
 	return 0;
 }
=20
-static int reclaim_pages(struct mlx5_core_dev *dev, u32 func_id, int npage=
s,
+static int reclaim_pages(struct mlx5_core_dev *dev, u16 func_id, int npage=
s,
 			 int *nclaimed, bool ec_function)
 {
+	u32 function =3D get_function(func_id, ec_function);
 	int outlen =3D MLX5_ST_SZ_BYTES(manage_pages_out);
 	u32 in[MLX5_ST_SZ_DW(manage_pages_in)] =3D {};
 	int num_claimed;
@@ -514,7 +524,7 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u32=
 func_id, int npages,
 	}
=20
 	for (i =3D 0; i < num_claimed; i++)
-		free_4k(dev, MLX5_GET64(manage_pages_out, out, pas[i]), func_id);
+		free_4k(dev, MLX5_GET64(manage_pages_out, out, pas[i]), function);
=20
 	if (nclaimed)
 		*nclaimed =3D num_claimed;
--=20
2.29.2

