Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8734F41B9E7
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 00:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243049AbhI1WJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 18:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243003AbhI1WJf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 18:09:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A62461357;
        Tue, 28 Sep 2021 22:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632866875;
        bh=bGJdsJGfySTNgdkIiC4cs97RHA14UA54yMOqudVCdzQ=;
        h=Date:From:To:Cc:Subject:From;
        b=BfdMLxcZc/xF1ud8tjWt4pwYBFEUtGCdKFqC+ambXqxza0WlPMs8FLuehzrvWywB5
         CApDW9V9enr97KLolM9lgINnwcU6dunz1WGjYOV12l6S9XvCcRGu9ZLtCR0vTs2phJ
         CxeFNewaP9SSFXbvKP2IwD9Ng7VXytZbNfBE3wa/dVIc/u68cP5Dc5H84w+DU3DfUH
         Br2afPXEUFX7vAC1WcFsiNo8BCXLXvP1qCQtpL//MYzpOCl6sxf7VxiDKZX16LYqpw
         spDlb59mKyIrxRYJALn31IvpPFSSgHUT1MkzQKO7sGxlo1GTJeMc42/6CRxrdNKjWh
         pmrZBemVZASHg==
Date:   Tue, 28 Sep 2021 17:11:57 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][net-next] net/mlx5: Use struct_size() helper in kvzalloc()
Message-ID: <20210928221157.GA278221@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version,
in order to avoid any potential type mistakes or integer overflows that,
in the worse scenario, could lead to heap overflows.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index 18e5aec14641..f542a36be62c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -497,8 +497,7 @@ static struct mlx5_fc_bulk *mlx5_fc_bulk_create(struct mlx5_core_dev *dev)
 	alloc_bitmask = MLX5_CAP_GEN(dev, flow_counter_bulk_alloc);
 	bulk_len = alloc_bitmask > 0 ? MLX5_FC_BULK_NUM_FCS(alloc_bitmask) : 1;
 
-	bulk = kvzalloc(sizeof(*bulk) + bulk_len * sizeof(struct mlx5_fc),
-			GFP_KERNEL);
+	bulk = kvzalloc(struct_size(bulk, fcs, bulk_len), GFP_KERNEL);
 	if (!bulk)
 		goto err_alloc_bulk;
 
-- 
2.27.0

