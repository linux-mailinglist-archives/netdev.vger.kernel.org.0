Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5981827F8B9
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 06:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgJAEda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 00:33:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgJAEdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 00:33:21 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BA8321D46;
        Thu,  1 Oct 2020 04:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601526799;
        bh=ghj7eo9a8XBk6uGZooMEAJF8wEuiFyf8eZk5z9ZMSg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLJiQnv0x7QM/Pxadu+lyAugRCWTHtLKfpoaqnh64dniUWoBzPSk3SsA+mSO1P1NR
         8oYSYo4+a0I39zr20Pb/tUJj6Rj7zoHpRc7Op9wBGOwSQDbMNLz+9MGpNgX2qLRtNL
         fzY1WQTuW6dspkNqv65EuCbAKO0P9b/oSLP9cWHY=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5: Fix dereference on pointer attr after null check
Date:   Wed, 30 Sep 2020 21:33:00 -0700
Message-Id: <20201001043302.48113-14-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001043302.48113-1-saeed@kernel.org>
References: <20201001043302.48113-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

When removing a flow from the slow path fdb, a flow attr struct is
allocated for the rule removal process. If the allocation fails the
code prints a warning message but continues with the removal flow
which include dereferencing a pointer which could be null.
Fix this by exiting the function in case the attr allocation failed.

Fixes: c620b772152b ("net/mlx5: Refactor tc flow attributes structure")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f815b0c60a6c..186dc2961000 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1238,8 +1238,10 @@ mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
 	struct mlx5_flow_attr *slow_attr;
 
 	slow_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
-	if (!slow_attr)
-		mlx5_core_warn(flow->priv->mdev, "Unable to unoffload slow path rule\n");
+	if (!slow_attr) {
+		mlx5_core_warn(flow->priv->mdev, "Unable to alloc attr to unoffload slow path rule\n");
+		return;
+	}
 
 	memcpy(slow_attr, flow->attr, ESW_FLOW_ATTR_SZ);
 	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-- 
2.26.2

