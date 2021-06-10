Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45AF3A2275
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhFJDAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229972AbhFJDAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1DCD6142F;
        Thu, 10 Jun 2021 02:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293902;
        bh=QFfRwo3ZUOZM+BB9WXwOvOWCCXJ1zZnhth52dw5YjrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWU9SXybAXiNL2O3HAn3hojFE83pwHR6c6s6q4jHeop5s0ArxAJ6WeIQW9cCCVR2A
         E7QUNWK5odIiWZKkG0aK7V/b4RM4gwvhoKXJVn9jI7Q5F5yGY5ozMxBQqqCHeBlQg6
         9GeoYOz1kuknZ2KZLiOCTtSy/uLEKE0Mzvty6UVQYFtl+Qcoxb8j/Mk+U7T6sPnM3M
         //MKDBaY7g7nvGbOwjgQMA33NkbXbBS82/YihoG3FbymqhpnhWyTG4n/7HDhoVZt81
         W4ULDR59X3aZF+BU5idZuXwZx5fBgs0luKe/D2DHoJ7LZqtRHf6xMxbDJurOkeqUUn
         jxAJdB/hwjvAg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/16] net/mlx5: Create TC-miss priority and table
Date:   Wed,  9 Jun 2021 19:58:05 -0700
Message-Id: <20210610025814.274607-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

In order to adhere to kernel software datapath model bridge offloads must
come after TC and NF FDBs. Following patches in this series add new FDB
priority for bridge after FDB_FT_OFFLOAD. However, since netfilter offload
is implemented with unmanaged tables, its miss path is not automatically
connected to next priority and requires the code to manually connect with
slow table. To keep bridge offloads encapsulated and not mix it with
eswitch offloads, create a new FDB_TC_MISS priority between FDB_FT_OFFLOAD
and FDB_SLOW_PATH:

          +
          |
+---------v----------+
|                    |
|   FDB_TC_OFFLOAD   |
|                    |
+---------+----------+
          |
          |
          |
+---------v----------+
|                    |
|   FDB_FT_OFFLOAD   |
|                    |
+---------+----------+
          |
          |
          |
+---------v----------+
|                    |
|    FDB_TC_MISS     |
|                    |
+---------+----------+
          |
          |
          |
+---------v----------+
|                    |
|   FDB_SLOW_PATH    |
|                    |
+---------+----------+
          |
          v

Initialize the new priority with single default empty managed table and use
the table as TC/NF miss patch instead of slow table. This approach allows
bridge offloads to be created as new FDB namespace priority between
FDB_TC_MISS and FDB_SLOW_PATH without exposing its internal tables to any
other modules since miss path of managed TC-miss table is automatically
wired to next priority.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 19 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  6 ++++++
 include/linux/mlx5/fs.h                       |  1 +
 4 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 64ccb2bc0b58..55404eabff39 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -196,6 +196,7 @@ struct mlx5_eswitch_fdb {
 
 		struct offloads_fdb {
 			struct mlx5_flow_namespace *ns;
+			struct mlx5_flow_table *tc_miss_table;
 			struct mlx5_flow_table *slow_fdb;
 			struct mlx5_flow_group *send_to_vport_grp;
 			struct mlx5_flow_group *send_to_vport_meta_grp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d18a28a6e9a6..7579f3402776 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1634,7 +1634,21 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	}
 	esw->fdb_table.offloads.slow_fdb = fdb;
 
-	err = esw_chains_create(esw, fdb);
+	/* Create empty TC-miss managed table. This allows plugging in following
+	 * priorities without directly exposing their level 0 table to
+	 * eswitch_offloads and passing it as miss_fdb to following call to
+	 * esw_chains_create().
+	 */
+	memset(&ft_attr, 0, sizeof(ft_attr));
+	ft_attr.prio = FDB_TC_MISS;
+	esw->fdb_table.offloads.tc_miss_table = mlx5_create_flow_table(root_ns, &ft_attr);
+	if (IS_ERR(esw->fdb_table.offloads.tc_miss_table)) {
+		err = PTR_ERR(esw->fdb_table.offloads.tc_miss_table);
+		esw_warn(dev, "Failed to create TC miss FDB Table err %d\n", err);
+		goto tc_miss_table_err;
+	}
+
+	err = esw_chains_create(esw, esw->fdb_table.offloads.tc_miss_table);
 	if (err) {
 		esw_warn(dev, "Failed to open fdb chains err(%d)\n", err);
 		goto fdb_chains_err;
@@ -1779,6 +1793,8 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 send_vport_err:
 	esw_chains_destroy(esw, esw_chains(esw));
 fdb_chains_err:
+	mlx5_destroy_flow_table(esw->fdb_table.offloads.tc_miss_table);
+tc_miss_table_err:
 	mlx5_destroy_flow_table(esw->fdb_table.offloads.slow_fdb);
 slow_fdb_err:
 	/* Holds true only as long as DMFS is the default */
@@ -1806,6 +1822,7 @@ static void esw_destroy_offloads_fdb_tables(struct mlx5_eswitch *esw)
 
 	esw_chains_destroy(esw, esw_chains(esw));
 
+	mlx5_destroy_flow_table(esw->fdb_table.offloads.tc_miss_table);
 	mlx5_destroy_flow_table(esw->fdb_table.offloads.slow_fdb);
 	/* Holds true only as long as DMFS is the default */
 	mlx5_flow_namespace_set_mode(esw->fdb_table.offloads.ns,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index c0936b4e53a9..fc70c4ed8469 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2780,6 +2780,12 @@ static int init_fdb_root_ns(struct mlx5_flow_steering *steering)
 	if (err)
 		goto out_err;
 
+	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_TC_MISS, 1);
+	if (IS_ERR(maj_prio)) {
+		err = PTR_ERR(maj_prio);
+		goto out_err;
+	}
+
 	maj_prio = fs_create_prio(&steering->fdb_root_ns->ns, FDB_SLOW_PATH, 1);
 	if (IS_ERR(maj_prio)) {
 		err = PTR_ERR(maj_prio);
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index f69f68fba946..271f2f4d6b60 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -87,6 +87,7 @@ enum {
 	FDB_BYPASS_PATH,
 	FDB_TC_OFFLOAD,
 	FDB_FT_OFFLOAD,
+	FDB_TC_MISS,
 	FDB_SLOW_PATH,
 	FDB_PER_VPORT,
 };
-- 
2.31.1

