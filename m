Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9515A42FF75
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239346AbhJPAlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239316AbhJPAlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:41:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C76EB61073;
        Sat, 16 Oct 2021 00:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634344747;
        bh=wbIKbgT4opwWW4ANMm1o2el72+DoctfjSU6QfGEk+WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eddTnWaQnvXKNBgjW3gFiAT9mpwVax5uhrH9XL90Gu0iGMPpK4gbkrFiDP3WfJLyA
         66viFNdTM3o/8F7UzMG9MHZJeWT6c9ga4DqKJGL6nJfuulc+i+SrxwVBPHKODPCMZe
         C4tcmhvPfnV4qxBI7FE8S1WY7etrI89FCriV6MtSOfhYAAJDK9KNlV5q7+pSJ5qLXG
         CgqcN3GC7qqkuHMM6eTSU4HkE51grnaFosE5uPc9kf0xH00eU2eNV1Csn8T0IlClUT
         HO+p4ijm2P9ADlNLTJ/8Y3ICKLM0Xtzle/86wbmeN68WKAZaGhwtUk0X5+kXhN4Qn/
         k0GjCAfuX8CMg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/13] net/mlx5: CT: Fix missing cleanup of ct nat table on init failure
Date:   Fri, 15 Oct 2021 17:38:56 -0700
Message-Id: <20211016003902.57116-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211016003902.57116-1-saeed@kernel.org>
References: <20211016003902.57116-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

If CT fails to initialize it's rhashtables, it doesn't destroy
the ct nat global table.

Destroy the ct nat global table on ct init failure.

Fixes: d7cade513752 ("net/mlx5e: check return value of rhashtable_init")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 225748a9e52a..740cd6f088b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -2141,6 +2141,7 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
 err_ct_tuples_ht:
 	rhashtable_destroy(&ct_priv->zone_ht);
 err_ct_zone_ht:
+	mlx5_chains_destroy_global_table(chains, ct_priv->ct_nat);
 err_ct_nat_tbl:
 	mlx5_chains_destroy_global_table(chains, ct_priv->ct);
 err_ct_tbl:
-- 
2.31.1

