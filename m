Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8952735E70F
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345992AbhDMTaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229963AbhDMTau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:30:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0147613CF;
        Tue, 13 Apr 2021 19:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618342230;
        bh=oQdl5ZZ6jluv6chnHO1d2IIfwhHTDi90Q3Z3knqF18U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMpjTzxXp6h/uKpvSjvaNfpgIQkjr8GFERJAH7vi9ZWi860wp0ZvQzazluIY9pKqb
         xxRQy9+dnvy0I51rt1ZKzkh+hM11a4EBsxO12eediOVY40GlhObjmLOSJE96b1jy6c
         D5lOYl6GQsyYhZaPBGdh9M1wlWC3Lo/e3G3WNjPQgMU7f82j5pUjeBNHYT+HD4Egcw
         IaWYEszzlIDB1FI0GKhYw6o3S9asfmE3xZwoNKXc5h33raqIhtsyTxmOpsNHb/CqjA
         MhEFtmkQDcfygSomaZee3YE5F09sDqqb61rajH9ELSggv2TAtKztMcWPGvOrKUJ7xp
         +7O+DpuGirtDA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/16] net/mlx5: E-Switch, Make vport number u16
Date:   Tue, 13 Apr 2021 12:29:53 -0700
Message-Id: <20210413193006.21650-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413193006.21650-1-saeed@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Vport number is 16-bit field in hardware. Make it u16.

Move location of vport in the structure so that it reduces a hole
in the structure.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h          | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
 include/linux/mlx5/eswitch.h                               | 3 +--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index c7a73dbd64b4..a4b9f78bf4d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -152,7 +152,6 @@ enum mlx5_eswitch_vport_event {
 
 struct mlx5_vport {
 	struct mlx5_core_dev    *dev;
-	int                     vport;
 	struct hlist_head       uc_list[MLX5_L2_ADDR_HASH_SIZE];
 	struct hlist_head       mc_list[MLX5_L2_ADDR_HASH_SIZE];
 	struct mlx5_flow_handle *promisc_rule;
@@ -174,6 +173,7 @@ struct mlx5_vport {
 		u32 max_rate;
 	} qos;
 
+	u16 vport;
 	bool                    enabled;
 	enum mlx5_eswitch_vport_event enabled_events;
 	struct devlink_port *dl_port;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 1f58e84bdfc6..bbb707117296 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -986,12 +986,13 @@ static void mlx5_eswitch_del_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
 static int
 mlx5_eswitch_add_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
 {
-	int num_vfs, vport_num, rule_idx = 0, err = 0;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {0};
+	int num_vfs, rule_idx = 0, err = 0;
 	struct mlx5_flow_handle *flow_rule;
 	struct mlx5_flow_handle **flows;
 	struct mlx5_flow_spec *spec;
+	u16 vport_num;
 
 	num_vfs = esw->esw_funcs.num_vfs;
 	flows = kvzalloc(num_vfs * sizeof(*flows), GFP_KERNEL);
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 429a710c5a99..9cf1da2883c6 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -152,8 +152,7 @@ mlx5_eswitch_vport_match_metadata_enabled(const struct mlx5_eswitch *esw)
 };
 
 static inline u32
-mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
-					  int vport_num)
+mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	return 0;
 };
-- 
2.30.2

