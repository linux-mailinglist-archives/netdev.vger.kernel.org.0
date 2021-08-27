Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE513F91C8
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244261AbhH0BAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243950AbhH0A7r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91185610E8;
        Fri, 27 Aug 2021 00:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025907;
        bh=5FpvOq1FHnl5p3V8uf4CGZam01w3aPsvsa5fseEIzyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMA6LhEWOk6mjvS5rqBSbfrmOmEvsNEYpbtf+nqrwU7p/xvjBz0Oxk3TJDTf9hFeX
         EruNOyB9CoAFQ2H/CMGTjG9YDNh1VYyvZTv9fL1y6AX7GGzQqM0xXHRY54VsOHKd/a
         AEFWQd+atdD9utEMofGjI4tOQkfHZQtrROjZd6AwE5D3hc6qkXYSXn3COK8fXARvAg
         20C0ZazFlkjVPBb44N41quxsH9jAREetMINcnI2p+anLxO2LpHcN5JoTY6Jvnr2kR3
         ikJ/a47jIQFKsxxK+vQxlk8ACKKj0NXzl0sG2XO92WzjQPPl6T02fyF6MKVvTb3QYo
         pd7tBl8M4zdBg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 17/17] net/mlx5: DR, Add support for update FTE
Date:   Thu, 26 Aug 2021 17:58:02 -0700
Message-Id: <20210827005802.236119-18-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add the support for update FTE, which is needed for cases where there are
multiple rules with the same match. In such case fs_core will merge the
actions and call update FTE to update current FTE. Since we don't want to
disrupt the traffic, we will add the new duplicate rule, and only then
remove the old duplicate rule.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/fs_dr.c       | 39 ++++++++++++++-----
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 633c9ec4c84e..7e58f4e594b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -625,15 +625,6 @@ static void mlx5_cmd_dr_modify_header_dealloc(struct mlx5_flow_root_namespace *n
 	mlx5dr_action_destroy(modify_hdr->action.dr_action);
 }
 
-static int mlx5_cmd_dr_update_fte(struct mlx5_flow_root_namespace *ns,
-				  struct mlx5_flow_table *ft,
-				  struct mlx5_flow_group *group,
-				  int modify_mask,
-				  struct fs_fte *fte)
-{
-	return -EOPNOTSUPP;
-}
-
 static int mlx5_cmd_dr_delete_fte(struct mlx5_flow_root_namespace *ns,
 				  struct mlx5_flow_table *ft,
 				  struct fs_fte *fte)
@@ -658,6 +649,36 @@ static int mlx5_cmd_dr_delete_fte(struct mlx5_flow_root_namespace *ns,
 	return 0;
 }
 
+static int mlx5_cmd_dr_update_fte(struct mlx5_flow_root_namespace *ns,
+				  struct mlx5_flow_table *ft,
+				  struct mlx5_flow_group *group,
+				  int modify_mask,
+				  struct fs_fte *fte)
+{
+	struct fs_fte fte_tmp = {};
+	int ret;
+
+	if (mlx5_dr_is_fw_table(ft->flags))
+		return mlx5_fs_cmd_get_fw_cmds()->update_fte(ns, ft, group, modify_mask, fte);
+
+	/* Backup current dr rule details */
+	fte_tmp.fs_dr_rule = fte->fs_dr_rule;
+	memset(&fte->fs_dr_rule, 0, sizeof(struct mlx5_fs_dr_rule));
+
+	/* First add the new updated rule, then delete the old rule */
+	ret = mlx5_cmd_dr_create_fte(ns, ft, group, fte);
+	if (ret)
+		goto restore_fte;
+
+	ret = mlx5_cmd_dr_delete_fte(ns, ft, &fte_tmp);
+	WARN_ONCE(ret, "dr update fte duplicate rule deletion failed\n");
+	return ret;
+
+restore_fte:
+	fte->fs_dr_rule = fte_tmp.fs_dr_rule;
+	return ret;
+}
+
 static int mlx5_cmd_dr_set_peer(struct mlx5_flow_root_namespace *ns,
 				struct mlx5_flow_root_namespace *peer_ns)
 {
-- 
2.31.1

