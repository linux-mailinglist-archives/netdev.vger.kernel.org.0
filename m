Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7671A3093A0
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhA3Joe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:44:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:33954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233420AbhA3DJ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:09:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8159864E0A;
        Sat, 30 Jan 2021 02:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973593;
        bh=gmarr4qVjyw751E10OSXeuOyiSWaDLjl7GR0aalT4MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/p9RIOeeOCUCtkVQDvViROd9OK3Q2VeP6FWJuU0Kf66mr3Gb37NSl5AGCzO13NZZ
         UYYAx4qQjRc86x545qZlyn+I0BKREpYV/GzhzPpjFYF9NHl+QeKbebQbyRVHi7JOmv
         klEegbR+neqzK/VC0AWU7ftTUD4iXFD+yiY+f7a8fqAkgoJHy2kHkg0BloOujVOMlP
         8bA22TjhWE11r6aiHY5wuZSzWb768qtzPHbzzDr8i3d30mDkpN+nhbyPkN1ezVCW7L
         yEcOOWWsCbWQh0m9TxSIZzb9L69niDfFfHqtX0BFcqEpt0yCiU/SV211/3rEBgfKlS
         1cHWJEj5VK/4g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/11] net/mlx5: DR, Use the right size when writing partial STE into HW
Date:   Fri, 29 Jan 2021 18:26:15 -0800
Message-Id: <20210130022618.317351-9-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210130022618.317351-1-saeed@kernel.org>
References: <20210130022618.317351-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

In these cases we need to update only the ctrl area of the STE.
So it is better to write only the control 32B and avoid copying
the unneeded reduced 48B (control 32B + tag 16B).

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c   | 12 ++++++++----
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c    |  2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index ddcb7017e121..fcea2a21abe9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -30,7 +30,7 @@ static int dr_rule_append_to_miss_list(struct mlx5dr_ste_ctx *ste_ctx,
 				 mlx5dr_ste_get_icm_addr(new_last_ste));
 	list_add_tail(&new_last_ste->miss_list_node, miss_list);
 
-	mlx5dr_send_fill_and_append_ste_send_info(last_ste, DR_STE_SIZE_REDUCED,
+	mlx5dr_send_fill_and_append_ste_send_info(last_ste, DR_STE_SIZE_CTRL,
 						  0, last_ste->hw_ste,
 						  ste_info_last, send_list, true);
 
@@ -110,10 +110,14 @@ dr_rule_handle_one_ste_in_update_list(struct mlx5dr_ste_send_info *ste_info,
 				       ste_info->size, ste_info->offset);
 	if (ret)
 		goto out;
-	/* Copy data to ste, only reduced size, the last 16B (mask)
+
+	/* Copy data to ste, only reduced size or control, the last 16B (mask)
 	 * is already written to the hw.
 	 */
-	memcpy(ste_info->ste->hw_ste, ste_info->data, DR_STE_SIZE_REDUCED);
+	if (ste_info->size == DR_STE_SIZE_CTRL)
+		memcpy(ste_info->ste->hw_ste, ste_info->data, DR_STE_SIZE_CTRL);
+	else
+		memcpy(ste_info->ste->hw_ste, ste_info->data, DR_STE_SIZE_REDUCED);
 
 out:
 	kfree(ste_info);
@@ -456,7 +460,7 @@ dr_rule_rehash_htbl(struct mlx5dr_rule *rule,
 		ste_to_update = cur_htbl->pointing_ste;
 	}
 
-	mlx5dr_send_fill_and_append_ste_send_info(ste_to_update, DR_STE_SIZE_REDUCED,
+	mlx5dr_send_fill_and_append_ste_send_info(ste_to_update, DR_STE_SIZE_CTRL,
 						  0, ste_to_update->hw_ste, ste_info,
 						  update_list, false);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 0f318f409c91..e21b61030e35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -264,7 +264,7 @@ static void dr_ste_remove_middle_ste(struct mlx5dr_ste_ctx *ste_ctx,
 	miss_addr = ste_ctx->get_miss_addr(ste->hw_ste);
 	ste_ctx->set_miss_addr(prev_ste->hw_ste, miss_addr);
 
-	mlx5dr_send_fill_and_append_ste_send_info(prev_ste, DR_STE_SIZE_REDUCED, 0,
+	mlx5dr_send_fill_and_append_ste_send_info(prev_ste, DR_STE_SIZE_CTRL, 0,
 						  prev_ste->hw_ste, ste_info,
 						  send_ste_list, true /* Copy data*/);
 
-- 
2.29.2

