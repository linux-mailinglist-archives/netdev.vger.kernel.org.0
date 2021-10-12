Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC3F42AE3B
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 22:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbhJLUzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 16:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:32976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235088AbhJLUzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 16:55:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 082D4610A2;
        Tue, 12 Oct 2021 20:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634072009;
        bh=uRlU2ZggC6qcmhJ8jHKphAFCa8E/YNY2y3ElhNPPUss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KU8jZSwYLgYAQCwiaXOa1metGbjayPCOOKo9oRIt4IJveX3dHhK8NEJS/lq+ZDf2d
         ai8HIK1bcFXUFqE0UrhU9//09rNaFE8c6wFwgWiTRLJEkUxQBjvzw3BZc0MbJIE/Hl
         P3o5iM/uEQ6fj+McAKdFQUBTHU2XS2HZCGaQC1hkzLkm26sjhdESVhrUCftoWJ4a5O
         MWHCbw4RQNISG1HaNTxJx1N9kq78QpDEW7EuK49mvvdWjZbcu7gOk4+PRn/l6+0sWa
         0QjIcb9KpdZsHAhfYJdj2JqVYQkEi1DMLmVFsQ4Aiw9yzq0WdB9Cm6fwKSFI1y8EiT
         HLw2x/Y9Ql0Yw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/6] net/mlx5e: Allow only complete TXQs partition in MQPRIO channel mode
Date:   Tue, 12 Oct 2021 13:53:19 -0700
Message-Id: <20211012205323.20123-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012205323.20123-1-saeed@kernel.org>
References: <20211012205323.20123-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Do not allow configurations of MQPRIO channel mode that do not
fully define and utilize the channels txqs.

Fixes: ec60c4581bd9 ("net/mlx5e: Support MQPRIO channel mode")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0c5197f9cea3..336aa07313da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2981,8 +2981,8 @@ static int mlx5e_mqprio_channel_validate(struct mlx5e_priv *priv,
 		agg_count += mqprio->qopt.count[i];
 	}
 
-	if (priv->channels.params.num_channels < agg_count) {
-		netdev_err(netdev, "Num of queues (%d) exceeds available (%d)\n",
+	if (priv->channels.params.num_channels != agg_count) {
+		netdev_err(netdev, "Num of queues (%d) does not match available (%d)\n",
 			   agg_count, priv->channels.params.num_channels);
 		return -EINVAL;
 	}
-- 
2.31.1

