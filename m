Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963AC3E9772
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhHKSSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:18:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229802AbhHKSSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:18:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DB216108C;
        Wed, 11 Aug 2021 18:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628705893;
        bh=SASyCz5oOjrzGahpVoJzbFyGP3nFJg1LNkcyfYhDoz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=su8j8Wll8QViMzj89lvgSWT2Wo+VdTVS6XXopLUkmaSallLbzM84PBBsyCrDM150e
         SZaWPgHfwazlpbMa7n5CE4VLDapmTKgaJXz6jPtEfO4tG2HQMKv8AkMlHkJHAQEYIq
         X0r7k1B0SG3KJ4yXDRW0LLsmrbNkVL59PrP8VHRFKTNUn63SMg39L2GdKvvyUQ3CSq
         QjRjWOcQaZWcvkVEIzisOSh5eAe0Ao0EfN4B+O+zm2KnY4gHhwKUp/pFkqw9+vI8uw
         AhjnDXiFNxyGCQeDaR4pDbfGEza0pzVs2Q9Rpi65bs8A2JGxqhrbMqvr73IYAEXbPu
         jEPhZDOXWotDA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/12] net/mlx5: Align mlx5_irq structure
Date:   Wed, 11 Aug 2021 11:16:50 -0700
Message-Id: <20210811181658.492548-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811181658.492548-1-saeed@kernel.org>
References: <20210811181658.492548-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

mlx5_irq structure have holes due to incorrect position of fields in it.
Make them naturally align.

pahole output after alignment:
struct mlx5_irq {
        struct atomic_notifier_head nh;                  /*     0    72 */
        /* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
        cpumask_var_t              mask;                 /*    72     8 */
        char                       name[32];             /*    80    32 */
        struct mlx5_irq_pool *     pool;                 /*   112     8 */
        struct kref                kref;                 /*   120     4 */
        u32                        index;                /*   124     4 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        int                        irqn;                 /*   128     4 */

        /* size: 136, cachelines: 3, members: 7 */
        /* padding: 4 */
        /* last cacheline: 8 bytes */

};

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 9fb75d79bf08..a4f6ba0c91da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -28,13 +28,13 @@
 #define MLX5_EQ_REFS_PER_IRQ (2)
 
 struct mlx5_irq {
-	u32 index;
 	struct atomic_notifier_head nh;
 	cpumask_var_t mask;
 	char name[MLX5_MAX_IRQ_NAME];
+	struct mlx5_irq_pool *pool;
 	struct kref kref;
+	u32 index;
 	int irqn;
-	struct mlx5_irq_pool *pool;
 };
 
 struct mlx5_irq_pool {
-- 
2.31.1

