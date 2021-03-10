Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E54334781
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbhCJTEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233764AbhCJTEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:04:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABABB64FCC;
        Wed, 10 Mar 2021 19:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403042;
        bh=bpVODYW5UVZnEOudgLhN4U32hjj1tMuDqmKxMhtCbaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5a3RTKNvIHauz8lFIDZblhgqd9No8wfH2wlNeIvmw1WDKVhFs/jSDzOm2eqhK4zz
         Y8tQHQwGO63ERS7ZuZ2w+QpB+HVNnDDN9pRLcB+qyC82qmnZoMfmdQuKR1reNUzLFL
         Dhpk8EttHIczCWthSLPdj93UXVNJzAfUGjiMnRfPE7+sL5XUCS0rhICXMGs7geCMnn
         S528onk6V/pJAdXBbvyuLpCRTj/CcAHamHKW0/6oybZAKiEcSUcBzf7jwUh0AeODUj
         y1/lsdHAULDummYOWhTw24qSL/kZTIkYZK6xBo4rf1Y0H3EhHTiNe3NhC/l2B9Buin
         rJSFhCLGUhXkg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 16/18] net/mlx5: SF: Fix memory leak of work item
Date:   Wed, 10 Mar 2021 11:03:40 -0800
Message-Id: <20210310190342.238957-17-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Cited patch in the fixes tag missed to free the allocated work.
Fix it by freeing the work after work execution.

Fixes: f3196bb0f14c ("net/mlx5: Introduce vhca state event notifier")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c
index af2f2dd9db25..f1c2068d4f2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/vhca_event.c
@@ -94,6 +94,7 @@ static void mlx5_vhca_state_work_handler(struct work_struct *_work)
 	struct mlx5_core_dev *dev = notifier->dev;
 
 	mlx5_vhca_event_notify(dev, &work->event);
+	kfree(work);
 }
 
 static int
-- 
2.29.2

