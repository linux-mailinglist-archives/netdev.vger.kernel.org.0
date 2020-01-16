Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD6413E3D7
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388453AbgAPRCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:02:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388036AbgAPRCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04F9D207FF;
        Thu, 16 Jan 2020 17:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194162;
        bh=DxDMkXN6W8HXA9Tv9UdkQdLIiC4v0uFN8JnUp4MuYaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7dM815HwtyBCpR5EmbF7N7NOBhiFqdfO1RAM1lSVKMJbEtTDuYEFWoatCqzwrCZv
         tleyxGE1W+FGV5FBaE1vuTfBtBrGo4BF/SknKzllZukF2BRluza5ntlOSVuPdVVmZ7
         ryu1kPcT/Qu8idP3sJh3elVk1a5ilrDtf4nILMQM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Britstein <elibr@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 243/671] net/mlx5: Fix multiple updates of steering rules in parallel
Date:   Thu, 16 Jan 2020 11:52:32 -0500
Message-Id: <20200116165940.10720-126-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

[ Upstream commit 6237634d8fcc65c9e3348382910e7cdb15084c68 ]

There might be a condition where the fte found is not active yet. In
this case we should not use it, but continue to search for another, or
allocate a new one.

Fixes: bd71b08ec2ee ("net/mlx5: Support multiple updates of steering rules in parallel")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 82a53317285d..b16e0f45d28c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -469,6 +469,7 @@ static void del_hw_fte(struct fs_node *node)
 			mlx5_core_warn(dev,
 				       "flow steering can't delete fte in index %d of flow group id %d\n",
 				       fte->index, fg->id);
+		node->active = 0;
 	}
 }
 
@@ -1597,6 +1598,11 @@ lookup_fte_locked(struct mlx5_flow_group *g,
 		fte_tmp = NULL;
 		goto out;
 	}
+	if (!fte_tmp->node.active) {
+		tree_put_node(&fte_tmp->node);
+		fte_tmp = NULL;
+		goto out;
+	}
 
 	nested_down_write_ref_node(&fte_tmp->node, FS_LOCK_CHILD);
 out:
-- 
2.20.1

