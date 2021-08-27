Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469FF3F91BA
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244215AbhH0A77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244110AbhH0A72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D16C161037;
        Fri, 27 Aug 2021 00:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025901;
        bh=xD23ZLihImcnR1vdd5VPkM9WkEKjE3xBTqUlmT10UPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEqQgbySpC0NcIuREKxUh5EdnflQY8cpMaLqiiHZhXodkff9VY27OSQ2LDbJi6s4X
         bUOdqGPsmUG/65LuGJb5+bdTcF+GOsLzuWEFK+w2f5kzh3eP0doYq68pUyOjTLq1mT
         OpCdEoV91hhl9lBoPgrrGUkh7MvWIgm8jHNVJDEbtXVCmChCNWxVL4yNdWn6WoFJFH
         /Us4z2zmdPuTjUwheYtDas4289hFxlGlNmJVuX5NT0RzOlN8ncknudNpZN8UpVf6z9
         IlxAhf8Xc0ZfBU4QeKRHMRmKri7FgaHbRLUHYvIjLqSnvwglL18G/+vHiZX/jGZggm
         RvxGmQyPI7SlQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/17] net/mlx5: DR, Use FW API when updating FW-owned flow table
Date:   Thu, 26 Aug 2021 17:57:55 -0700
Message-Id: <20210827005802.236119-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Need to call the DR API only when it is DR table.
To update FW-owned table the driver should call the FW API.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 7bfcb3456cf2..6ea4a0988062 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -133,6 +133,9 @@ static int mlx5_cmd_dr_modify_flow_table(struct mlx5_flow_root_namespace *ns,
 					 struct mlx5_flow_table *ft,
 					 struct mlx5_flow_table *next_ft)
 {
+	if (mlx5_dr_is_fw_table(ft->flags))
+		return mlx5_fs_cmd_get_fw_cmds()->modify_flow_table(ns, ft, next_ft);
+
 	return set_miss_action(ns, ft, next_ft);
 }
 
-- 
2.31.1

