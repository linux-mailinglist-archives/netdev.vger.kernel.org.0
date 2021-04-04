Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30ACE35366F
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbhDDEUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhDDEUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE65961384;
        Sun,  4 Apr 2021 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510010;
        bh=bHjoskws+MsLwRhSSVRoZ42cmlUxxqhQQ2ly1XTbKo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ay/1mGozLf8raNMfzJTBB0UOx3gHtEg3eTA8b9J5VVJ+im8m/Uz1Tqg9EU4veilmo
         pzQ7aM8Bl4i9sJU4ma0b3jCEMM6waYnRmTq6iG6xU7hqem8lqEXIxawrjOOLWestHp
         +Xty8JlsWqGlpNHniCN4Iax/s9i0iB3FVr6jo9Drot5ObMXyb8cczfkAWFsw4jv4QY
         THp6BCGm2E9bLJLKSle1Ngt06fYEJ2MxRkqyZX7ixhBo2IoSPuAMdh9YNvKzdwBfz0
         BiTIlqNZ9MZiIArIMyR2MinbPoedcdPFZmzMQ8fTchVuw/Sr/QoS+XhwwPRB6k1i6f
         VrGXsNHEf0mhw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/16] net/mlx5: Use helper to increment, decrement rate entry refcount
Date:   Sat,  3 Apr 2021 21:19:46 -0700
Message-Id: <20210404041954.146958-9-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Rate limit entry refcount can be incremented uniformly when it is newly
allocated or reused.
So simplify the code to increment refcount at one place.

Use decrement refcount helper in two routines.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/rl.c | 34 +++++++++++---------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rl.c b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
index 208fd3cad970..08792fe701e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
@@ -201,6 +201,19 @@ static void mlx5_rl_table_free(struct mlx5_core_dev *dev, struct mlx5_rl_table *
 	kfree(table->rl_entry);
 }
 
+static void mlx5_rl_entry_get(struct mlx5_rl_entry *entry)
+{
+	entry->refcount++;
+}
+
+static void
+mlx5_rl_entry_put(struct mlx5_core_dev *dev, struct mlx5_rl_entry *entry)
+{
+	entry->refcount--;
+	if (!entry->refcount)
+		mlx5_set_pp_rate_limit_cmd(dev, entry, false);
+}
+
 int mlx5_rl_add_rate_raw(struct mlx5_core_dev *dev, void *rl_in, u16 uid,
 			 bool dedicated_entry, u16 *index)
 {
@@ -228,13 +241,10 @@ int mlx5_rl_add_rate_raw(struct mlx5_core_dev *dev, void *rl_in, u16 uid,
 		err = -ENOSPC;
 		goto out;
 	}
-	if (entry->refcount) {
-		/* rate already configured */
-		entry->refcount++;
-	} else {
+	if (!entry->refcount) {
+		/* new rate limit */
 		memcpy(entry->rl_raw, rl_in, sizeof(entry->rl_raw));
 		entry->uid = uid;
-		/* new rate limit */
 		err = mlx5_set_pp_rate_limit_cmd(dev, entry, true);
 		if (err) {
 			mlx5_core_err(
@@ -248,9 +258,9 @@ int mlx5_rl_add_rate_raw(struct mlx5_core_dev *dev, void *rl_in, u16 uid,
 			goto out;
 		}
 
-		entry->refcount = 1;
 		entry->dedicated = dedicated_entry;
 	}
+	mlx5_rl_entry_get(entry);
 	*index = entry->index;
 
 out:
@@ -266,10 +276,7 @@ void mlx5_rl_remove_rate_raw(struct mlx5_core_dev *dev, u16 index)
 
 	mutex_lock(&table->rl_lock);
 	entry = &table->rl_entry[index - 1];
-	entry->refcount--;
-	if (!entry->refcount)
-		/* need to remove rate */
-		mlx5_set_pp_rate_limit_cmd(dev, entry, false);
+	mlx5_rl_entry_put(dev, entry);
 	mutex_unlock(&table->rl_lock);
 }
 EXPORT_SYMBOL(mlx5_rl_remove_rate_raw);
@@ -317,12 +324,7 @@ void mlx5_rl_remove_rate(struct mlx5_core_dev *dev, struct mlx5_rate_limit *rl)
 			       rl->rate, rl->max_burst_sz, rl->typical_pkt_sz);
 		goto out;
 	}
-
-	entry->refcount--;
-	if (!entry->refcount)
-		/* need to remove rate */
-		mlx5_set_pp_rate_limit_cmd(dev, entry, false);
-
+	mlx5_rl_entry_put(dev, entry);
 out:
 	mutex_unlock(&table->rl_lock);
 }
-- 
2.30.2

