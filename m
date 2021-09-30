Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C4541E4BB
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350609AbhI3XW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350124AbhI3XWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C680861A40;
        Thu, 30 Sep 2021 23:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044061;
        bh=cU/c9wSp94zapS5RHJ9QXpnePUeA7D43U8DDZ4VxQ24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbHFN+3gVcFUozOkvDMoy0EI3JCqmk80LSXVLcvFOjG1hBtltmdmH3u1Desh8Fg23
         bi1EGIQNKn4zFlx2rdOOFjg8TEzjxyjHt094BtpzLyz9v5lMScNJKZ+KJeP7UDydON
         W7LJ4C/rSCk6ex+OjaNysvKDVPIAR2WHWRce7h1ue3N//JnM07ObhlLa8AX52HBP/e
         fmXajyX8faxr8sq6qyQ7D14rfXHmco6n55hGTVXOnc6MrqD10tzuPE0jHJSE0rWoMn
         1x4G+ktWLRmo+4HhWxVRj4xf+05Vag+A+YGJ7epiK1IU19E6JRDmbGZ72zzu8n8/ue
         SX18NT43CxD3Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5: Use struct_size() helper in kvzalloc()
Date:   Thu, 30 Sep 2021 16:20:49 -0700
Message-Id: <20210930232050.41779-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

Make use of the struct_size() helper instead of an open-coded version,
in order to avoid any potential type mistakes or integer overflows that,
in the worse scenario, could lead to heap overflows.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
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
2.31.1

