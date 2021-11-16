Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90959453AE8
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhKPU0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:26:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230100AbhKPU0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:26:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8423061ABD;
        Tue, 16 Nov 2021 20:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637094218;
        bh=oYGrJK83oOSC4G32iI2jNRI+7Bw7S9ydd8eBR80MClU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQsImMRf+2SNYPxvMGUIjqOOyunc4VajfyvCKiUkfP4zj45zm0+efC8teCbO1jsQO
         DM5mKSHskr2VzwE3RKDOk8WQy7Mdu8fHOxIuhmkwgnXXOKGTx7cOLwsDh8FMO4OxSJ
         9AdYlutA62Pyim0zJf1o/CGzvQLDlsOnO5XuZ1IJnsezSvW5SxE2yx8gERZHknNQuf
         MpRq1ccw00izCi2CTgydPj2lDBK39fF5Az5xBFFqg28CWt2+1MwE2bKJItYuWHocwO
         fwMLvzwLrF0cxpVuCKt1do+ZhKJHFOqC6XrkpQzUDDS2IGSCkVQzIatuRX6xzgZkn1
         Q9wM77mKjQDKw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/12] net/mlx5: E-Switch, rebuild lag only when needed
Date:   Tue, 16 Nov 2021 12:23:17 -0800
Message-Id: <20211116202321.283874-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116202321.283874-1-saeed@kernel.org>
References: <20211116202321.283874-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

A user can enable VFs without changing E-Switch mode, this can happen
when a user moves straight to switchdev mode and only once in switchdev
VFs are enabled via the sysfs interface.

The cited commit assumed this isn't possible and exposed a single
API function where the E-switch calls into the lag code, breaks the lag
and prevents any other lag operations to take place until the
E-switch update has ended.

Breaking the hardware lag when it isn't needed can make it such that
hardware lag can't be enabled again.

In the sysfs call path check if the current E-Switch mode is NONE,
in the context of the function it can only mean the E-Switch is moving
out of NONE mode and the hardware lag should be disabled and enabled
once the mode change has ended. If the mode isn't NONE it means
VFs are about to be enabled and such operation doesn't require
toggling the hardware lag.

Fixes: cac1eb2cf2e3 ("net/mlx5: Lag, properly lock eswitch if needed")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 5872cc8bf953..51a8cecc4a7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1305,12 +1305,17 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
  */
 int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 {
+	bool toggle_lag;
 	int ret;
 
 	if (!mlx5_esw_allowed(esw))
 		return 0;
 
-	mlx5_lag_disable_change(esw->dev);
+	toggle_lag = esw->mode == MLX5_ESWITCH_NONE;
+
+	if (toggle_lag)
+		mlx5_lag_disable_change(esw->dev);
+
 	down_write(&esw->mode_lock);
 	if (esw->mode == MLX5_ESWITCH_NONE) {
 		ret = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY, num_vfs);
@@ -1324,7 +1329,10 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 			esw->esw_funcs.num_vfs = num_vfs;
 	}
 	up_write(&esw->mode_lock);
-	mlx5_lag_enable_change(esw->dev);
+
+	if (toggle_lag)
+		mlx5_lag_enable_change(esw->dev);
+
 	return ret;
 }
 
-- 
2.31.1

