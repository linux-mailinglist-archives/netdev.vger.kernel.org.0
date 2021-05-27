Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C493935B7
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbhE0S6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236167AbhE0S6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:58:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B01F60FF1;
        Thu, 27 May 2021 18:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141800;
        bh=q70lOhaKZeARksTYZ1PjL3Lp20SX8Cr6mosHxZISN8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfbOy/haeZaFqEAfhZopNicJhKmfPtUG6X1PaVX69V/4tEAX8xhnaZLLxN2+plLjq
         W1AxXNnReOXZSZGarSfqt7P9E0rZ6bQYpyXnq/V1BGYrYzL0pvw4XifhCHmNlvE81c
         glLr3JlUeyoBGwdwcjpsO56Mbig48V4/MfBxDQdgfPjdlbxzLDszARYzmFmCR00Kxc
         aJKT082VuGYoEHqy8h0u8417V5yfsYubpZxtxJlvpBV5TIpsbaOh5mtEpJKwlzM5C1
         gYZidqg9c1i9+uI1BBk3bjwmXT/BLnIOpf7kl0ct0uNHasAE6uJPfSrkuL+X5SC4+I
         lCL2SCDms1zOw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 12/15] net/mlx5: Cap the maximum flow group size to 16M entries
Date:   Thu, 27 May 2021 11:56:21 -0700
Message-Id: <20210527185624.694304-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527185624.694304-1-saeed@kernel.org>
References: <20210527185624.694304-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

The maximum number of large flow groups applies to both small and large
tables. For very large tables (such as the 2G SW steering tables) this may
create a small number of flow groups each with an unrealistic entries
domain (> 16M).

Set the maximum number of large flow groups to at least what user
requested, but with a maximum per group size of 16M entries.
For software steering, if user requested less than 128 large flow
groups, it will gives us about 128 16M groups in a 2G
entries tables.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 6e20cbb4656a..1b7a1cde097c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1173,6 +1173,7 @@ mlx5_create_lag_demux_flow_table(struct mlx5_flow_namespace *ns,
 }
 EXPORT_SYMBOL(mlx5_create_lag_demux_flow_table);
 
+#define MAX_FLOW_GROUP_SIZE BIT(24)
 struct mlx5_flow_table*
 mlx5_create_auto_grouped_flow_table(struct mlx5_flow_namespace *ns,
 				    struct mlx5_flow_table_attr *ft_attr)
@@ -1192,6 +1193,10 @@ mlx5_create_auto_grouped_flow_table(struct mlx5_flow_namespace *ns,
 	if (num_reserved_entries > ft->max_fte)
 		goto err_validate;
 
+	/* Align the number of groups according to the largest group size */
+	if (autogroups_max_fte / (max_num_groups + 1) > MAX_FLOW_GROUP_SIZE)
+		max_num_groups = (autogroups_max_fte / MAX_FLOW_GROUP_SIZE) - 1;
+
 	ft->autogroup.active = true;
 	ft->autogroup.required_groups = max_num_groups;
 	ft->autogroup.max_fte = autogroups_max_fte;
-- 
2.31.1

