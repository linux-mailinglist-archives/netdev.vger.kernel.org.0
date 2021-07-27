Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71763D83D8
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhG0XVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233173AbhG0XU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:20:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB74A60F9D;
        Tue, 27 Jul 2021 23:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627428057;
        bh=UEBetwmTrildB+RjV4mzCaZ7CcH42WJ35PXDqP/mUZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5oJtNDgNtoJLKPcaZlTz0eco/tCsC6oaItrMUvDGJHuVcu1qnGRJLCf2rf5+z8MU
         l7G90lsp3yF4ng75QLppjG2dPBjJuWf8VWUPMJUXxGQUthxoLROpLBFUCKL/LBOrOs
         Kj6THo+Xjq98SBItYez0O3kTigpSoGNKcm1uoee9JpE2QtYo+FITgYkOEJryk9N6ZV
         hZh6kaJKVThmM8tckZtai6LQAlcPHQghN/SlVFsZMReEiwS2Pw0BG0coG2H/mNQjz/
         FdVQNoq9pEI2LtEVbXCeV0t+1+edc76EnjY9c7A/tVWGmXB/l6lqUa+4xm4GjfZtvt
         kd5LpueSxpDEg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 09/12] net/mlx5e: Fix page allocation failure for ptp-RQ over SF
Date:   Tue, 27 Jul 2021 16:20:47 -0700
Message-Id: <20210727232050.606896-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727232050.606896-1-saeed@kernel.org>
References: <20210727232050.606896-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Set the correct pci-device pointer to the ptp-RQ. This allows access to
dma_mask and avoids allocation request with wrong pci-device.

Fixes: a099da8ffcf6 ("net/mlx5e: Add RQ to PTP channel")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 07b429b94d93..efef4adce086 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -497,7 +497,7 @@ static int mlx5e_init_ptp_rq(struct mlx5e_ptp *c, struct mlx5e_params *params,
 	int err;
 
 	rq->wq_type      = params->rq_wq_type;
-	rq->pdev         = mdev->device;
+	rq->pdev         = c->pdev;
 	rq->netdev       = priv->netdev;
 	rq->priv         = priv;
 	rq->clock        = &mdev->clock;
-- 
2.31.1

