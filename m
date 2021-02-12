Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A44319871
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhBLC7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:59:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229829AbhBLC6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B6A164E70;
        Fri, 12 Feb 2021 02:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098646;
        bh=a6gPRPl7rLNezkzZYWfAWfGR46aniDGKwMeyIgQDxns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQSI7XvesYUhNmvAYOnT/yUwXc/keAIn9Bck7kdiEoQh9pO2VUbBleZAc7tXCQuz6
         +o3tKK8LwiBJU9RzJXCKWFt22FCsbvusKcytZP4ihIcCq1EzHswL4gT3qE0bK0c/vL
         +e49vA2l9NUbY6QqTdkUAu28ijKQVqtE+bUSrOknAq+Bd2yqgS/NygbvCKHIa1WsJp
         rod9q3HbU2YrRghpr4WQpQ73EN5pjGk/qcxZw4lck557SQei+6oJkWh+3Ql0imm2K8
         XIUUF64nN4uSB4gI2U12t1hZ0tRvqd7nOP1qb+EyZ92PrPaxlTfpGev097dbIac9E8
         VmgfEk8RcDewQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 12/15] net/mlx5: Disallow RoCE on lag device
Date:   Thu, 11 Feb 2021 18:56:38 -0800
Message-Id: <20210212025641.323844-13-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

In lag mode, setting roce enabled/disable of lag device have no effect.
e.g.: bond device (roce/vf_lag) roce status remain unchanged.
Therefore disable it and add an error message.

Fixes: cc9defcbb8fa ("net/mlx5: Handle "enable_roce" devlink param")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 317ce6b80b23..c7073193db14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -273,8 +273,8 @@ static int mlx5_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
 		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support RoCE");
 		return -EOPNOTSUPP;
 	}
-	if (mlx5_core_is_mp_slave(dev)) {
-		NL_SET_ERR_MSG_MOD(extack, "Multi port slave device can't configure RoCE");
+	if (mlx5_core_is_mp_slave(dev) || mlx5_lag_is_active(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Multi port slave/Lag device can't configure RoCE");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.29.2

