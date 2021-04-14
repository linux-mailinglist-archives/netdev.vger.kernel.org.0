Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2BA35FA3C
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352064AbhDNSGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352028AbhDNSGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:06:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDDFE611F0;
        Wed, 14 Apr 2021 18:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618423573;
        bh=QE5BjsecPS8smzIIeP1Gy3FWZzvWrJ7/XLdUReSmp4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MohP9QojAQ1qYo2/7MMooqdp9FAoDQiwCkZO860nrYcxk11P7ovvsNitxmHAHAeTH
         ZB38spbZ/BMX0+N9pWHvbhKkJmacWQlGK7QLYVVXaLIMg2tlWjUpKzTqU0pniIysKx
         BQtA29n+kYPOVubnTYGu0B1rVWIxvI8qtyHwfpwW1ccFC/BtwdiePxY5XjlKDI34bh
         v7tpb+4vjwAvXnsp2t9lqVNZRxB5kNJqLCZkmUYoFwqwItfg33OVonfcy65N+FRpGn
         NkeWT0FfKA9YFEFh1TEylqIg3qpCty/IGvPI+Jlj7vYuj+yo5b4QwvQ3oBVdUwObuG
         CRC+OmKMLTlrQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 02/16] net/mlx5: E-Switch, Skip querying SF enabled bits
Date:   Wed, 14 Apr 2021 11:05:51 -0700
Message-Id: <20210414180605.111070-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414180605.111070-1-saeed@kernel.org>
References: <20210414180605.111070-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

With vhca events, SF state is queried through the VHCA events. Device no
longer expects SF bitmap in the query eswitch functions command.

Hence, remove it to simplify the code.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6cf04a366f99..b3bc82e419b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1390,15 +1390,9 @@ const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 {
 	int outlen = MLX5_ST_SZ_BYTES(query_esw_functions_out);
 	u32 in[MLX5_ST_SZ_DW(query_esw_functions_in)] = {};
-	u16 max_sf_vports;
 	u32 *out;
 	int err;
 
-	max_sf_vports = mlx5_sf_max_functions(dev);
-	/* Device interface is array of 64-bits */
-	if (max_sf_vports)
-		outlen += DIV_ROUND_UP(max_sf_vports, BITS_PER_TYPE(__be64)) * sizeof(__be64);
-
 	out = kvzalloc(outlen, GFP_KERNEL);
 	if (!out)
 		return ERR_PTR(-ENOMEM);
-- 
2.30.2

