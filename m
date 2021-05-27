Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD84A392679
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbhE0EiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229899AbhE0EiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:38:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D49E5613CC;
        Thu, 27 May 2021 04:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622090194;
        bh=47XmjZ9lIAGJGFHkUS4jO8otskT8KMwjqhqghWzDZSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duOEW47C3Pk9zuPDT3a4jSWgzvh/P1q7xWgnzV8pozKoRQLut63+qI04kVpGF1gsP
         UBTz0NhvcV3c3wkmuCs+Gkg0yDBc96ddQJXMmAXcG+ILnxUc4cyXfOdvkShH3SchqC
         Xdan2180A9wpBAkTzseCAsXR8YkWRasjSQeaGwttyC3t5U8f9+xynr86mt0j2cazEQ
         q9erFZThf0DWV3Co/vgJv7XvUZzCoDA5RLhecO6dPoM9CYpxn7GEr5yreTTs6cB0Jm
         uwW7Tbo2/wBObzPGlSJ9QMw9jf55N0l3qaODu/DyuG/1HftRlO0mOwVSa9SgbK6/Pd
         uHEKKJopWUpqQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/17] net/mlx5e: RX, Remove unnecessary check in RX CQE compression handling
Date:   Wed, 26 May 2021 21:35:58 -0700
Message-Id: <20210527043609.654854-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527043609.654854-1-saeed@kernel.org>
References: <20210527043609.654854-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

There are two reasons for exiting mlx5e_decompress_cqes_cont():
1. The compression session is completed (cqd.left == 0).
2. The budget is exhausted (work_done == budget).

If after calling mlx5e_decompress_cqes_cont() we have cqd.left > 0,
it necessarily implies that budget is exhausted.

The first part of the complex condition is covered by the second,
hence we remove it here.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 5346271974f5..e88429356018 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1560,7 +1560,7 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 
 	if (rq->cqd.left) {
 		work_done += mlx5e_decompress_cqes_cont(rq, cqwq, 0, budget);
-		if (rq->cqd.left || work_done >= budget)
+		if (work_done >= budget)
 			goto out;
 	}
 
-- 
2.31.1

