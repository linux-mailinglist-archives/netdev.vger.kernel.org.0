Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB48A350808
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhCaURN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236475AbhCaUQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 16:16:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89A60610A0;
        Wed, 31 Mar 2021 20:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617221800;
        bh=gAUVsOq48G5Uo7ndalvuqfA6JvmNdD+zShEVsrHkwh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIDMGJ/gioMSwC2IUl/8/ZQYVH03lXqpGNbI5XMhBlMR9rf80zHmVrviUZ2hh91yI
         /Uqai371dQHVP8V4Ca1BI4bKWkHrOjlBRk5b1mPYmfaPv6sTwq0WpNFKeI6WOcIUOu
         IMcal1fAlNMxOmDjstIST9AAJbCnScu8/65GHxmJPCwB3EJTX4Wv/YSGfxhsCmIu/s
         rZbuZWOfraSskcRu2WPDzBM59+ExYLtGDZG3PlWDuksW9wWCBmwOhrVD7HrjUxOxqX
         vCd3pyo49BkaIxAKHI7zQMouka5bXuGK8eJTv31ooy1CoTvnSH626DrjPOZhOAnjyJ
         WoL/QS9H2OalQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 7/9] net/mlx5: Don't request more than supported EQs
Date:   Wed, 31 Mar 2021 13:14:22 -0700
Message-Id: <20210331201424.331095-8-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331201424.331095-1-saeed@kernel.org>
References: <20210331201424.331095-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Calculating the number of compeltion EQs based on the number of
available IRQ vectors doesn't work now that all async EQs share one IRQ.
Thus the max number of EQs can be exceeded on systems with more than
approximately 256 CPUs. Take this into account when calculating the
number of available completion EQs.

Fixes: 81bfa206032a ("net/mlx5: Use a single IRQ for all async EQs")
Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 174dfbc996c6..1fa9c18563da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -931,13 +931,24 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 	mutex_unlock(&table->lock);
 }
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+#define MLX5_MAX_ASYNC_EQS 4
+#else
+#define MLX5_MAX_ASYNC_EQS 3
+#endif
+
 int mlx5_eq_table_create(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
+	int num_eqs = MLX5_CAP_GEN(dev, max_num_eqs) ?
+		      MLX5_CAP_GEN(dev, max_num_eqs) :
+		      1 << MLX5_CAP_GEN(dev, log_max_eq);
 	int err;
 
 	eq_table->num_comp_eqs =
-		mlx5_irq_get_num_comp(eq_table->irq_table);
+		min_t(int,
+		      mlx5_irq_get_num_comp(eq_table->irq_table),
+		      num_eqs - MLX5_MAX_ASYNC_EQS);
 
 	err = create_async_eqs(dev);
 	if (err) {
-- 
2.30.2

