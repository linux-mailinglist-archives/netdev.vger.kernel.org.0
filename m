Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE88C8807
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 14:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfJBMMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 08:12:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:49230 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbfJBMMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 08:12:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6E6F5AC10;
        Wed,  2 Oct 2019 12:12:43 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D74DAE04C7; Wed,  2 Oct 2019 14:12:41 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] mlx5: avoid 64-bit division in dr_icm_pool_mr_create()
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Alex Vesker <valex@mellanox.com>, Borislav Petkov <bp@alien8.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20191002121241.D74DAE04C7@unicorn.suse.cz>
Date:   Wed,  2 Oct 2019 14:12:41 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently added code introduces 64-bit division in dr_icm_pool_mr_create()
so that build on 32-bit architectures fails with

  ERROR: "__umoddi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!

As the divisor is always a power of 2, we can use bitwise operation
instead.

Fixes: 29cf8febd185 ("net/mlx5: DR, ICM pool memory allocator")
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 913f1e5aaaf2..d7c7467e2d53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -137,7 +137,8 @@ dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool,
 
 	icm_mr->icm_start_addr = icm_mr->dm.addr;
 
-	align_diff = icm_mr->icm_start_addr % align_base;
+	/* align_base is always a power of 2 */
+	align_diff = icm_mr->icm_start_addr & (align_base - 1);
 	if (align_diff)
 		icm_mr->used_length = align_base - align_diff;
 
-- 
2.23.0

