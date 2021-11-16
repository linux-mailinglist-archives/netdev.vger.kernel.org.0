Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE06453AE9
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhKPU0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:26:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230115AbhKPU0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:26:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CBBF61AED;
        Tue, 16 Nov 2021 20:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637094220;
        bh=wXjCcDI/OM9uHIfVcGhB+l2/kyjdT7sV/2XpW6K6iv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ9NdiBIEAA/+UypAN6ryUJzbX8rZSLqDVFIY2mc25AJNOClSmo8TyRsWK9JBRaLk
         nje5IelwqMO/WcVGz789S2TyGpmhq3NUYt4q7XSu9U4QQRNZNZRLkI4f+L1JaTLs+Z
         FiuxWNPkKK+jy051HbEGfwWanaazmUAfOrcB5YYhAA/MU8Yw2YFuqC+Wz0uZ29IDC/
         +vu55+R5K3hSRr0I5Mr/auBn3MrLo2w646RqtAX5CxkloEggDIyPB5p9k7dEY12Fso
         EOoWUE4Lq5Z3A7aZ47T3XCwpHG+YfX8c55HtspWZBrV+K+PVdC1V2lQZNxYI5BXdJT
         80hZ0uIK3NPrQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 12/12] net/mlx5: E-Switch, return error if encap isn't supported
Date:   Tue, 16 Nov 2021 12:23:21 -0800
Message-Id: <20211116202321.283874-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116202321.283874-1-saeed@kernel.org>
References: <20211116202321.283874-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

On regular ConnectX HCAs getting encap mode isn't supported when the
E-Switch is in NONE mode. Current code would return no error code when
trying to get encap mode in such case which is wrong.

Fix by returning error value to indicate failure to caller in such case.

Fixes: 8e0aa4bc959c ("net/mlx5: E-switch, Protect eswitch mode changes")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 80fa76f60e1e..a46455694f7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3623,7 +3623,7 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 	*encap = esw->offloads.encap;
 unlock:
 	up_write(&esw->mode_lock);
-	return 0;
+	return err;
 }
 
 static bool
-- 
2.31.1

