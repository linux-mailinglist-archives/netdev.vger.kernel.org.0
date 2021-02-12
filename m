Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF83319870
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhBLC70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:59:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhBLC6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4715B64E66;
        Fri, 12 Feb 2021 02:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098646;
        bh=OYvZFT69xYtVoMbPhXQyvJVeQckx5i//YryLeoiMVZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+uPgpbotjr4hPtfhCk7e3Et2SJV1if6Le1rh/wQkjDLayqgbT7L1MbN6Ky/S36dk
         dIX4ydBuaqg3AEzdQ2nWjgLD2Pcj6S5SMWNr73OhzUEByw8OBmwxmlJfWQtc2u1F2z
         TSAsgx+nEdqWmWNsFJ69phggQyqVegpG7SELv3CUwR6+e+EHQ8i8mKMATa1m1VDSOD
         ydgCtlUIxrQxshp44NN5i2LWvt4FWfS18bGqNVa/FOOoX0n1YGW+hFBKyRIa9993WD
         LS/aSCRuK0v1NIcpGFG+OjnJBuEa9CEscpuvO47qFKcK+AcwWz3QULwA7Kvww4oc45
         AqlknmM/eGJcw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/15] net/mlx5: Disallow RoCE on multi port slave device
Date:   Thu, 11 Feb 2021 18:56:37 -0800
Message-Id: <20210212025641.323844-12-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

In dual port mode, setting roce enabled/disable for the slave device
have no effect. e.g.: the slave device roce status remain unchanged.
Therefore disable it and add an error message.
Enable or disable roce of the master device affect both master and slave
devices.

Fixes: cc9defcbb8fa ("net/mlx5: Handle "enable_roce" devlink param")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 3261d0dc1104..317ce6b80b23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -273,6 +273,10 @@ static int mlx5_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
 		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support RoCE");
 		return -EOPNOTSUPP;
 	}
+	if (mlx5_core_is_mp_slave(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Multi port slave device can't configure RoCE");
+		return -EOPNOTSUPP;
+	}
 
 	return 0;
 }
-- 
2.29.2

