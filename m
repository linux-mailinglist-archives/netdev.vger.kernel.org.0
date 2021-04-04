Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99B935366E
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbhDDEUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231975AbhDDEUN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AE056137B;
        Sun,  4 Apr 2021 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510009;
        bh=d5HjqsRv+vVfSbRfiM4c4gmiZaxqGsC46/imwxGOsw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGLBtl+Yz9xq63zBzjQJXV0wXD5UE2oeKGK5ZKw3YTk2xIYffvI2YTiW/7uk31xb2
         jzePBcsHfrUxCBpCxeOFm8UaWJ4DxW2lrxgJv5wRgFfEtOXBn4BTNlD3u7Xro+018a
         2pQQKaYIE/Hh+GSzU2THJEiBK0Obnn4F5yvMWhivCHdLpi7Su879NjflVKmmgXWQMl
         bYEfmh3vM3X6BAPE87+/rX8qGr1Uueo1HwinB1LNnm0cncC+3VCojUOodRMoJOh0Gm
         iIRG6qV14wb7M7SkUE3HrClaqo7sdr7GTTJqZy35ikW/EARFwCFIDrekH3Bp3FhLRB
         Wfj4QCwiQUaqg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/16] net/mlx5: Use helpers to allocate and free rl table entries
Date:   Sat,  3 Apr 2021 21:19:45 -0700
Message-Id: <20210404041954.146958-8-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

User helper routines to allocate and free rate limit table entries.
Subsequent patch extends use of these helpers to do allocation
during rate entry allocation callback.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/rl.c | 55 +++++++++++++-------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rl.c b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
index 2accc0f324f3..208fd3cad970 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
@@ -172,6 +172,35 @@ bool mlx5_rl_are_equal(struct mlx5_rate_limit *rl_0,
 }
 EXPORT_SYMBOL(mlx5_rl_are_equal);
 
+static int mlx5_rl_table_alloc(struct mlx5_rl_table *table)
+{
+	int i;
+
+	table->rl_entry = kcalloc(table->max_size, sizeof(struct mlx5_rl_entry),
+				  GFP_KERNEL);
+	if (!table->rl_entry)
+		return -ENOMEM;
+
+	/* The index represents the index in HW rate limit table
+	 * Index 0 is reserved for unlimited rate
+	 */
+	for (i = 0; i < table->max_size; i++)
+		table->rl_entry[i].index = i + 1;
+
+	return 0;
+}
+
+static void mlx5_rl_table_free(struct mlx5_core_dev *dev, struct mlx5_rl_table *table)
+{
+	int i;
+
+	/* Clear all configured rates */
+	for (i = 0; i < table->max_size; i++)
+		if (table->rl_entry[i].refcount)
+			mlx5_set_pp_rate_limit_cmd(dev, &table->rl_entry[i], false);
+	kfree(table->rl_entry);
+}
+
 int mlx5_rl_add_rate_raw(struct mlx5_core_dev *dev, void *rl_in, u16 uid,
 			 bool dedicated_entry, u16 *index)
 {
@@ -302,7 +331,7 @@ EXPORT_SYMBOL(mlx5_rl_remove_rate);
 int mlx5_init_rl_table(struct mlx5_core_dev *dev)
 {
 	struct mlx5_rl_table *table = &dev->priv.rl_table;
-	int i;
+	int err;
 
 	mutex_init(&table->rl_lock);
 	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, packet_pacing)) {
@@ -315,18 +344,10 @@ int mlx5_init_rl_table(struct mlx5_core_dev *dev)
 	table->max_rate = MLX5_CAP_QOS(dev, packet_pacing_max_rate);
 	table->min_rate = MLX5_CAP_QOS(dev, packet_pacing_min_rate);
 
-	table->rl_entry = kcalloc(table->max_size, sizeof(struct mlx5_rl_entry),
-				  GFP_KERNEL);
-	if (!table->rl_entry)
-		return -ENOMEM;
-
-	/* The index represents the index in HW rate limit table
-	 * Index 0 is reserved for unlimited rate
-	 */
-	for (i = 0; i < table->max_size; i++)
-		table->rl_entry[i].index = i + 1;
+	err = mlx5_rl_table_alloc(table);
+	if (err)
+		return err;
 
-	/* Index 0 is reserved */
 	mlx5_core_info(dev, "Rate limit: %u rates are supported, range: %uMbps to %uMbps\n",
 		       table->max_size,
 		       table->min_rate >> 10,
@@ -338,13 +359,9 @@ int mlx5_init_rl_table(struct mlx5_core_dev *dev)
 void mlx5_cleanup_rl_table(struct mlx5_core_dev *dev)
 {
 	struct mlx5_rl_table *table = &dev->priv.rl_table;
-	int i;
 
-	/* Clear all configured rates */
-	for (i = 0; i < table->max_size; i++)
-		if (table->rl_entry[i].refcount)
-			mlx5_set_pp_rate_limit_cmd(dev, &table->rl_entry[i],
-						   false);
+	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, packet_pacing))
+		return;
 
-	kfree(dev->priv.rl_table.rl_entry);
+	mlx5_rl_table_free(dev, table);
 }
-- 
2.30.2

