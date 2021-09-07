Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D56403041
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 23:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348530AbhIGVZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 17:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348393AbhIGVZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 17:25:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41C8461104;
        Tue,  7 Sep 2021 21:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631049871;
        bh=VfUqhtbPGXtwFIwhDWKRb7VjcBd409QOqHQzoGa6gMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zmn+toGdm1ZFk//hbG9rYeqHJ1T+Emnpmu6lfMi0yw/LEeujzvDZgIWy3t8oExB2K
         nSmYMW/OlqQ70chMmHR5nZVxiJ4nrCFmFKpfRKgvqTQXWhkGMz2hKh3DRJbxFB9RbA
         booCMoGozTnQIVghzRHSDXiFQvev8j9HtiwIh/c+KhM+kvF3hW3ShcZpu0rMk7qI5P
         VyYas3urM0JNCYm31tnAFPnLAw2m7yax2GNKkUvLJJYMapc9naMI/jeVtovz8sIzuW
         scbO5Rrcp6ZD8+8qCUFO8mNKqUDEtjUOgM88ql+4PkR0S182kUFnQ4+FbfbvrdZQ/K
         LnxqUXEGnjQ4g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 7/7] net/mlx5e: Fix condition when retrieving PTP-rqn
Date:   Tue,  7 Sep 2021 14:24:20 -0700
Message-Id: <20210907212420.28529-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210907212420.28529-1-saeed@kernel.org>
References: <20210907212420.28529-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When activating the PTP-RQ, redirect the RQT from drop-RQ to PTP-RQ.
Use mlx5e_channels_get_ptp_rqn to retrieve the rqn. This helper returns
a boolean (not status), hence caller should consider return value 0 as a
fail. Change the caller interpretation of the return value.

Fixes: 43ec0f41fa73 ("net/mlx5e: Hide all implementation details of mlx5e_rx_res")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
index bf0313e2682b..13056cb9757d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c
@@ -572,7 +572,7 @@ void mlx5e_rx_res_channels_activate(struct mlx5e_rx_res *res, struct mlx5e_chann
 	if (res->features & MLX5E_RX_RES_FEATURE_PTP) {
 		u32 rqn;
 
-		if (mlx5e_channels_get_ptp_rqn(chs, &rqn))
+		if (!mlx5e_channels_get_ptp_rqn(chs, &rqn))
 			rqn = res->drop_rqn;
 
 		err = mlx5e_rqt_redirect_direct(&res->ptp.rqt, rqn);
-- 
2.31.1

