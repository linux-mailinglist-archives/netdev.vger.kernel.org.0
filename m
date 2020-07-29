Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05032327B9
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 00:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgG2WwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 18:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgG2WwF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 18:52:05 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3639D207E8;
        Wed, 29 Jul 2020 22:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596063124;
        bh=lzsxfpDng3IN/YT0VQwa+MpZyW3DuOOoDwauH2Jinns=;
        h=Date:From:To:Cc:Subject:From;
        b=IcBxDhJcOO80LxJIeOrnwXy/+Wjv8LOQ9iAG3+DsG5DKFJOkjPgnFLcDXSaAB33hS
         3m9LlV00zIRuKCOjqDkkNnzJ43RcJ4mciS3bjfXoCAW5MJnA9I8ypFzsT6y511Ihey
         RrLHk38gytyLIUupLbBwxBSFdPmywNTWOeWlFcXk=
Date:   Wed, 29 Jul 2020 17:58:03 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] mlxsw: spectrum_cnt: Use flex_array_size() helper in
 memcpy()
Message-ID: <20200729225803.GA15866@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the flex_array_size() helper to calculate the size of a
flexible array member within an enclosing structure.

This helper offers defense-in-depth against potential integer
overflows, while at the same time makes it explicitly clear that
we are dealing witha flexible array member.

Also, remove unnecessary pointer identifier sub_pool.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
index 7974982533b5..b65b93a2b9bc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
@@ -121,7 +121,6 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 {
 	unsigned int sub_pools_count = ARRAY_SIZE(mlxsw_sp_counter_sub_pools);
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
-	struct mlxsw_sp_counter_sub_pool *sub_pool;
 	struct mlxsw_sp_counter_pool *pool;
 	unsigned int map_size;
 	int err;
@@ -131,9 +130,9 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	if (!pool)
 		return -ENOMEM;
 	mlxsw_sp->counter_pool = pool;
-	memcpy(pool->sub_pools, mlxsw_sp_counter_sub_pools,
-	       sub_pools_count * sizeof(*sub_pool));
 	pool->sub_pools_count = sub_pools_count;
+	memcpy(pool->sub_pools, mlxsw_sp_counter_sub_pools,
+	       flex_array_size(pool, sub_pools, pool->sub_pools_count));
 	spin_lock_init(&pool->counter_pool_lock);
 	atomic_set(&pool->active_entries_count, 0);
 
-- 
2.27.0

