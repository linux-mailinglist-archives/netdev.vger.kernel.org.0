Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0DE392681
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235008AbhE0Eig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233542AbhE0EiN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:38:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E94C613D1;
        Thu, 27 May 2021 04:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622090200;
        bh=lKTulkTziS+NkGD49gosC0fNNCWb++ScrOK49DGw3Zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9pSe9nwJ2XRWWf+sRfS4KiEQV05JN2TAU73kN5/B+5ptmO+dtYcFEtCOJ/y//B01
         RTj7l7dB37gEDDEzjOmE06gQconcKmBUfwVn0eGUjqWmproAPwUgQ8upVSXv95IqLs
         qLNbMPcBZOGsXxJ2SS4SWO9KDzayosb869axWgvs5Wcjl/LrAJXOt5h4hyookBJ7/9
         q+ITWQKx+4/uFlQAzPbyebJavWN4SlRYRdq33UEY5QK2gPzeYn1lrznpxwXxxxNjsw
         UdISYvWZg98y7IZbReOBLgowEWCnep/yKYdQZ7n5C8BQtXyqlng23YamvRS3oLfgqZ
         EIwIUGcnl+H7Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/17] net/mlx5: Use boolean arithmetic to evaluate roce_lag
Date:   Wed, 26 May 2021 21:36:06 -0700
Message-Id: <20210527043609.654854-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527043609.654854-1-saeed@kernel.org>
References: <20210527043609.654854-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Avoid mixing boolean and bit arithmetic when evaluating validity of
roce_lag.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index c9c00163d918..e52e2144ab12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -289,8 +289,9 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 			   !mlx5_sriov_is_enabled(dev1);
 
 #ifdef CONFIG_MLX5_ESWITCH
-		roce_lag &= dev0->priv.eswitch->mode == MLX5_ESWITCH_NONE &&
-			    dev1->priv.eswitch->mode == MLX5_ESWITCH_NONE;
+		roce_lag = roce_lag &&
+			   dev0->priv.eswitch->mode == MLX5_ESWITCH_NONE &&
+			   dev1->priv.eswitch->mode == MLX5_ESWITCH_NONE;
 #endif
 
 		if (roce_lag)
-- 
2.31.1

