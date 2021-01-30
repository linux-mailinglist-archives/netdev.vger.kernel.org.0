Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A8E3091D2
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 05:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhA3ERG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 23:17:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233648AbhA3DtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:49:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1935C64E12;
        Sat, 30 Jan 2021 02:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973594;
        bh=h9JPR8VxnRfFhQQVCL5oxI2YDswTOIc988xmDb61Eos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqYJSIT+U0FYxLvKbrba2PBsJCQqiL2itEEQW0tCRPWHkjNEKAudTUg6Q4wRD3sez
         /pG9ALSN4PfDtYk41d0hJpz9h/KbWaaU5hnDFz+nveQPUzBnobfH8mgqbR946Ooenh
         faMyK2sKheSuboOle4Mgh2tv5hJPJDeuibqWmzA0Ya3ZyYQSOWM/V1ukclcQ8hJRQS
         RSU0tIPGWIXl4XWKcGrvHV/pgA+K1TzhucApDVtRL2t9/DYN1riVV9/n+3uftbIzGl
         ee0x3kApk1X20ZQdpN/1YNTc4GrnWvDhMmHY3QV6C4kh8zQxFis2ehR8V4Lc6qhYuR
         8H76AOLdBB+xw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/11] net/mlx5: DR, Copy all 64B whenever replacing STE in the head of miss-list
Date:   Fri, 29 Jan 2021 18:26:17 -0800
Message-Id: <20210130022618.317351-11-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210130022618.317351-1-saeed@kernel.org>
References: <20210130022618.317351-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Till now the code assumed that need to copy reduced size of the
ste because the rest is the mask part which shouldn't be changed.
This is not true for all types of HW (like STEv1).
Take all 64B from the new STE and write them in the replaced STE place.
This change will make it easier to handle all STE HW types because we have
all the data that is about to be written into HW.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste.c      | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 8ac3ccdda84c..9cd5c50c5d42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -211,13 +211,17 @@ dr_ste_remove_head_ste(struct mlx5dr_ste_ctx *ste_ctx,
  * |_ste_| --> |_next_ste_| -->|__| -->|__| -->/0
  */
 static void
-dr_ste_replace_head_ste(struct mlx5dr_ste *ste, struct mlx5dr_ste *next_ste,
+dr_ste_replace_head_ste(struct mlx5dr_matcher_rx_tx *nic_matcher,
+			struct mlx5dr_ste *ste,
+			struct mlx5dr_ste *next_ste,
 			struct mlx5dr_ste_send_info *ste_info_head,
 			struct list_head *send_ste_list,
 			struct mlx5dr_ste_htbl *stats_tbl)
 
 {
 	struct mlx5dr_ste_htbl *next_miss_htbl;
+	u8 hw_ste[DR_STE_SIZE] = {};
+	int sb_idx;
 
 	next_miss_htbl = next_ste->htbl;
 
@@ -230,13 +234,19 @@ dr_ste_replace_head_ste(struct mlx5dr_ste *ste, struct mlx5dr_ste *next_ste,
 	/* Move data from next into ste */
 	dr_ste_replace(ste, next_ste);
 
+	/* Copy all 64 hw_ste bytes */
+	memcpy(hw_ste, ste->hw_ste, DR_STE_SIZE_REDUCED);
+	sb_idx = ste->ste_chain_location - 1;
+	mlx5dr_ste_set_bit_mask(hw_ste,
+				nic_matcher->ste_builder[sb_idx].bit_mask);
+
 	/* Del the htbl that contains the next_ste.
 	 * The origin htbl stay with the same number of entries.
 	 */
 	mlx5dr_htbl_put(next_miss_htbl);
 
-	mlx5dr_send_fill_and_append_ste_send_info(ste, DR_STE_SIZE_REDUCED,
-						  0, ste->hw_ste,
+	mlx5dr_send_fill_and_append_ste_send_info(ste, DR_STE_SIZE,
+						  0, hw_ste,
 						  ste_info_head,
 						  send_ste_list,
 						  true /* Copy data */);
@@ -316,7 +326,8 @@ void mlx5dr_ste_free(struct mlx5dr_ste *ste,
 					       stats_tbl);
 		} else {
 			/* First but not only entry in the list */
-			dr_ste_replace_head_ste(ste, next_ste, &ste_info_head,
+			dr_ste_replace_head_ste(nic_matcher, ste,
+						next_ste, &ste_info_head,
 						&send_ste_list, stats_tbl);
 			put_on_origin_table = false;
 		}
-- 
2.29.2

