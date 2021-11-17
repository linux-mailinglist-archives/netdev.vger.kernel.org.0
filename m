Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4EE9453F87
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhKQEhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229984AbhKQEhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1CBC615E6;
        Wed, 17 Nov 2021 04:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123647;
        bh=WXQX7ZfRe82hnCr/RGXlB8TjAxGKGZILcZVzR93BQrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uX/lg8aEDuNGCA8UIBEE7KXJAAryRgeCR7/c6fUCgROrkBetcoblvuIstWTKdCT9T
         kz7fT2Fq28r5yitFQwVdaAt5mwtmXWA9I1no67jEYL7Ky+UHnBJCz6ICySg38NyZAy
         pXtTJKQHZBERcF0FZ+xa/iEMnbpFwYZ2sh5Sgf4Yh0LZQNSfcWwHHmoL4wmxshguAU
         sW51E07G9X5H7tp1pFAXGoU782MEGAjjm9bd7Yp8vBUzxo0czt/putnUZHQ6NhfdAH
         UV2GoJicMm+N38gvYcB8fA9kIjMo7o6y4U0HhZLkafyDfYKvYsDqt6BhPH/DtwyGSN
         qTlI/1xJUmrLw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next v0 02/15] net/mlx5: Fix format-security build warnings
Date:   Tue, 16 Nov 2021 20:33:44 -0800
Message-Id: <20211117043357.345072-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Treat the string as an argument to avoid this.

drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c:482:5:
error: format string is not a string literal (potentially insecure)
                         name);
                         ^~~~
drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:2079:4:
error: format string is not a string literal (potentially insecure)
                        ptp_ch_stats_desc[i].format);
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 2a9bfc3ffa2e..3c91a11e27ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2076,7 +2076,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(ptp)
 
 	for (i = 0; i < NUM_PTP_CH_STATS; i++)
 		sprintf(data + (idx++) * ETH_GSTRING_LEN,
-			ptp_ch_stats_desc[i].format);
+			"%s", ptp_ch_stats_desc[i].format);
 
 	if (priv->tx_ptp_opened) {
 		for (tc = 0; tc < priv->max_opened_tc; tc++)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 830444f927d4..19bf2b66707d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -479,7 +479,7 @@ irq_pool_alloc(struct mlx5_core_dev *dev, int start, int size, char *name,
 	pool->xa_num_irqs.max = start + size - 1;
 	if (name)
 		snprintf(pool->name, MLX5_MAX_IRQ_NAME - MLX5_MAX_IRQ_IDX_CHARS,
-			 name);
+			 "%s", name);
 	pool->min_threshold = min_threshold * MLX5_EQ_REFS_PER_IRQ;
 	pool->max_threshold = max_threshold * MLX5_EQ_REFS_PER_IRQ;
 	mlx5_core_dbg(dev, "pool->name = %s, pool->size = %d, pool->start = %d",
-- 
2.31.1

