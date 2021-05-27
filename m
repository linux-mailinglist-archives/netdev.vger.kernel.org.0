Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B556E392680
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbhE0Eif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233887AbhE0EiM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:38:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B15E6613CC;
        Thu, 27 May 2021 04:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622090200;
        bh=CSQasfwmKg2NPJe8IFW2daWcYTYHC5GI9DF3P7UvjhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHft5KbAytfW7I9J4SkstT9Jn7cBTbD0NNSqVVmrubYErDj8BEEYIJno93JdHQZC4
         QaR8rubxzpIDBFMB66Nu1yOLPmdSrITf94CiPS5oBBrlRo/W12ge7gYpa7qdN7jW44
         Vz1XcWaaOkVncH6bOCbw7swb5NDRPNHYMTajSVShd1dI51eLSiwnm6G74X36gMvhkc
         mxMmlFtEdObPlRJlcp9hY6BIEpU0/7pG/sjv1FMHfghJxtNHLUcuDOr1YME241s0+r
         vWmUra8lt4S6v3DnFpSQMuFlMzQPI1cvkIEQDvF6Rm0D1yGu+6ax0MuTTwJmJ5lGMS
         6b2GLfuEd/jNQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/17] net/mlx5: Remove unnecessary spin lock protection
Date:   Wed, 26 May 2021 21:36:05 -0700
Message-Id: <20210527043609.654854-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527043609.654854-1-saeed@kernel.org>
References: <20210527043609.654854-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Taking lag_lock to access ldev->tracker is meaningless in the context of
do_bond() and mlx5_lag_netdev_event().

Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index b8748390335f..c9c00163d918 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -280,9 +280,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 	if (!mlx5_lag_is_ready(ldev))
 		return;
 
-	spin_lock(&lag_lock);
 	tracker = ldev->tracker;
-	spin_unlock(&lag_lock);
 
 	do_bond = tracker.is_bonded && mlx5_lag_check_prereq(ldev);
 
@@ -481,9 +479,7 @@ static int mlx5_lag_netdev_event(struct notifier_block *this,
 		break;
 	}
 
-	spin_lock(&lag_lock);
 	ldev->tracker = tracker;
-	spin_unlock(&lag_lock);
 
 	if (changed)
 		mlx5_queue_bond_work(ldev, 0);
-- 
2.31.1

